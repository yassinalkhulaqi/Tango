import 'package:dio/dio.dart';
import 'api_exception.dart';

typedef TokenRefresher = Future<String?> Function();

enum RetryCause { none, network, serverError }

class RetryConfig {
  const RetryConfig({
    this.maxRetries = 2,
    this.baseDelay = const Duration(milliseconds: 250),
    this.maxDelay = const Duration(seconds: 4),
  });

  final int maxRetries;
  final Duration baseDelay;
  final Duration maxDelay;
}

class RetryPolicy {
  const RetryPolicy._();

  static bool isIdempotent(String method) => method.toUpperCase() == 'GET';

  static RetryCause causeOf(DioException error) {
    final statusCode = error.response?.statusCode;
    if (statusCode != null && statusCode >= 500) return RetryCause.serverError;
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return RetryCause.network;
      default:
        return RetryCause.none;
    }
  }

  static bool shouldRetry({
    required String method,
    required int attempt,
    required int maxRetries,
    required RetryCause cause,
  }) {
    if (cause == RetryCause.none || !isIdempotent(method)) return false;
    return attempt >= 0 && attempt < maxRetries;
  }

  static Duration backoffFor({
    required int attempt,
    required Duration baseDelay,
    required Duration maxDelay,
  }) {
    final shift = attempt < 0 ? 0 : (attempt > 30 ? 30 : attempt);
    final micros = baseDelay.inMicroseconds * (1 << shift);
    final limit = maxDelay.inMicroseconds;
    return Duration(microseconds: micros > limit ? limit : micros);
  }
}

class ApiMeta {
  const ApiMeta({
    this.page,
    this.perPage,
    this.total,
    this.hasMore,
    this.extra = const <String, dynamic>{},
  });

  final int? page;
  final int? perPage;
  final int? total;
  final bool? hasMore;
  final Map<String, dynamic> extra;

  factory ApiMeta.fromJson(Map<String, dynamic> json) {
    const known = <String>{
      'page',
      'perPage',
      'per_page',
      'limit',
      'total',
      'totalItems',
      'count',
      'hasMore',
    };
    final extra = <String, dynamic>{};
    json.forEach((key, value) {
      if (!known.contains(key)) extra[key] = value;
    });
    return ApiMeta(
      page: _intOf(json['page']),
      perPage: _intOf(json['perPage'] ?? json['per_page'] ?? json['limit']),
      total: _intOf(json['total'] ?? json['totalItems'] ?? json['count']),
      hasMore: json['hasMore'] is bool ? json['hasMore'] as bool : null,
      extra: extra,
    );
  }

  static int? _intOf(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}

class ListEnvelope<T> {
  const ListEnvelope({required this.items, required this.meta});

  final List<T> items;
  final ApiMeta meta;
}

class ApiListParser {
  const ApiListParser._();

  static ListEnvelope<T> parse<T>(
    Map<String, dynamic> body,
    T Function(Map<String, dynamic> json) fromJson, {
    String dataKey = 'data',
    String metaKey = 'meta',
  }) {
    final rawData = body[dataKey];
    final rawMeta = body[metaKey];
    final meta = rawMeta is Map
        ? ApiMeta.fromJson(Map<String, dynamic>.from(rawMeta))
        : const ApiMeta();
    return ListEnvelope<T>(
      items: _rowsOf(rawData)
          .whereType<Map>()
          .map((row) => fromJson(Map<String, dynamic>.from(row)))
          .toList(),
      meta: meta,
    );
  }

  static List<Object?> _rowsOf(Object? rawData) {
    if (rawData is List) return rawData;
    if (rawData is Map) {
      final data = Map<String, dynamic>.from(rawData);
      final nested =
          data['items'] ?? data['data'] ?? data['results'] ?? data['rows'];
      if (nested is List) return nested;
    }
    if (rawData == null) return const <Object?>[];
    return <Object?>[rawData];
  }
}

class ApiClient {
  ApiClient({
    required this.baseUrl,
    Dio? dio,
    this.retryConfig = const RetryConfig(),
  }) : _dio = dio ?? Dio(_baseOptions(baseUrl)) {
    _auth = AuthHeadersInterceptor(null);
    _dio.interceptors.add(_auth);
  }

  final String baseUrl;
  final Dio _dio;
  final RetryConfig retryConfig;
  late final AuthHeadersInterceptor _auth;
  TokenRefresher? _refresher;
  Future<String?>? _refreshInFlight;

  static BaseOptions _baseOptions(String baseUrl) => BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
    headers: {'Content-Type': 'application/json'},
  );

  void setAccessToken(String? token) => _auth.setToken(token);

  void setTokenRefresher(TokenRefresher refresher) => _refresher = refresher;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) => _request('GET', path, queryParameters: queryParameters);

  Future<Map<String, dynamic>> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) => _request('POST', path, data: data, queryParameters: queryParameters);

  Future<Map<String, dynamic>> patch(String path, {Object? data}) =>
      _request('PATCH', path, data: data);

  Future<Map<String, dynamic>> delete(String path) => _request('DELETE', path);

  Future<ListEnvelope<T>> getList<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic> json) fromJson,
  }) async {
    final body = await get(path, queryParameters: queryParameters);
    return ApiListParser.parse<T>(body, fromJson);
  }

  Future<Map<String, dynamic>> _request(
    String method,
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    var attempt = 0;
    var refreshed = false;
    while (true) {
      try {
        final response = await _dio.request<Map<String, dynamic>>(
          path,
          data: data,
          queryParameters: queryParameters,
          options: Options(method: method),
        );
        return _decodeBody(response.data);
      } on DioException catch (error) {
        if (error.response?.statusCode == 401 &&
            !refreshed &&
            _refresher != null) {
          final token = await _refreshAccessToken();
          if (token != null && token.isNotEmpty) {
            refreshed = true;
            _auth.setToken(token);
            continue;
          }
        }
        final cause = RetryPolicy.causeOf(error);
        if (RetryPolicy.shouldRetry(
          method: method,
          attempt: attempt,
          maxRetries: retryConfig.maxRetries,
          cause: cause,
        )) {
          final delay = RetryPolicy.backoffFor(
            attempt: attempt,
            baseDelay: retryConfig.baseDelay,
            maxDelay: retryConfig.maxDelay,
          );
          attempt++;
          if (delay.inMicroseconds > 0) await Future<void>.delayed(delay);
          continue;
        }
        throw _mapError(error);
      }
    }
  }

  Future<String?> _refreshAccessToken() async {
    final inFlight = _refreshInFlight;
    final future =
        inFlight ??
        _refresher!().whenComplete(() {
          _refreshInFlight = null;
        });
    if (inFlight == null) _refreshInFlight = future;
    try {
      return await future;
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> _decodeBody(Object? body) {
    if (body is Map<String, dynamic>) return body;
    if (body is Map) return Map<String, dynamic>.from(body);
    throw const ApiException(
      code: 'bad_response',
      message: 'Invalid server response.',
    );
  }

  ApiException _mapError(DioException error) {
    final body = error.response?.data;
    if (body is Map) {
      return ApiException.fromJson(
        Map<String, dynamic>.from(body),
        statusCode: error.response?.statusCode,
      );
    }
    return ApiException(
      code: 'network_error',
      message: error.type == DioExceptionType.connectionTimeout
          ? 'Connection timed out. Check your internet connection.'
          : 'Cannot reach the server. Your progress is saved on this device.',
      statusCode: error.response?.statusCode,
    );
  }
}

class AuthHeadersInterceptor extends Interceptor {
  AuthHeadersInterceptor(this._token);

  String? _token;

  void setToken(String? token) => _token = token;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_token != null && _token!.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $_token';
    }
    super.onRequest(options, handler);
  }
}
