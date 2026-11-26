import 'package:dio/dio.dart';
import 'api_exception.dart';

class ApiClient {
  ApiClient({required this.baseUrl, Dio? dio})
    : _dio = dio ?? Dio(_baseOptions(baseUrl)) {
    _auth = AuthHeadersInterceptor(null);
    _dio.interceptors.add(_auth);
  }

  final String baseUrl;
  final Dio _dio;
  late final AuthHeadersInterceptor _auth;

  static BaseOptions _baseOptions(String baseUrl) => BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
    headers: {'Content-Type': 'application/json'},
  );

  void setAccessToken(String? token) => _auth.setToken(token);

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

  Future<Map<String, dynamic>> _request(
    String method,
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.request<Map<String, dynamic>>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(method: method),
      );
      final body = response.data;
      if (body is Map<String, dynamic>) return body;
      if (body is Map) return Map<String, dynamic>.from(body);
      throw const ApiException(
        code: 'bad_response',
        message: 'Invalid server response.',
      );
    } on DioException catch (e) {
      final body = e.response?.data;
      if (body is Map) {
        throw ApiException.fromJson(
          Map<String, dynamic>.from(body),
          statusCode: e.response?.statusCode,
        );
      }
      throw ApiException(
        code: 'network_error',
        message: e.type == DioExceptionType.connectionTimeout
            ? 'Connection timed out. Check your internet connection.'
            : 'Cannot reach the server. Your progress is saved on this device.',
        statusCode: e.response?.statusCode,
      );
    }
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
