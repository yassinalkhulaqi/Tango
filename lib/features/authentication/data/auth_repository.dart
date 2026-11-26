import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/providers.dart';
import '../../../core/state/app_providers.dart';

typedef SessionReader = AuthSession Function();
typedef SessionRestorer = Future<void> Function();

Map<String, dynamic> _dataOf(Map<String, dynamic> body) {
  final raw = body['data'];
  if (raw is Map) return Map<String, dynamic>.from(raw);
  if (raw is List && raw.isNotEmpty && raw.first is Map) {
    return Map<String, dynamic>.from(raw.first as Map);
  }
  return body;
}

Map<String, dynamic> _tokensOf(
  Map<String, dynamic> body,
  Map<String, dynamic> data,
) {
  final raw = data['tokens'] ?? body['tokens'];
  if (raw is Map) return Map<String, dynamic>.from(raw);
  return <String, dynamic>{...body, ...data};
}

String? _firstString(Map<String, dynamic> source, List<String> keys) {
  for (final key in keys) {
    final value = source[key];
    if (value == null) continue;
    final text = value.toString();
    if (text.isNotEmpty) return text;
  }
  return null;
}

AuthSession parseAuthSession(Map<String, dynamic> body) {
  final data = _dataOf(body);
  final tokens = _tokensOf(body, data);
  final access =
      _firstString(tokens, const ['accessToken', 'access_token', 'token']) ??
      _firstString(data, const ['accessToken', 'access_token', 'token']) ??
      _firstString(body, const ['accessToken', 'access_token', 'token']);
  if (access == null) {
    throw const ApiException(
      code: 'missing_token',
      message: 'The server did not return an access token.',
    );
  }
  final refresh =
      _firstString(tokens, const ['refreshToken', 'refresh_token']) ??
      _firstString(data, const ['refreshToken', 'refresh_token']) ??
      _firstString(body, const ['refreshToken', 'refresh_token']);
  final user = data['user'] is Map
      ? Map<String, dynamic>.from(data['user'] as Map)
      : <String, dynamic>{};
  final userId =
      _firstString(user, const ['id', '_id', 'userId']) ??
      _firstString(data, const ['userId', 'user_id']) ??
      _firstString(body, const ['userId', 'user_id']);
  return AuthSession(
    accessToken: access,
    refreshToken: refresh,
    userId: userId,
    status: AuthStatus.authenticated,
  );
}

class AuthRepository {
  AuthRepository(this._api, {this.sessionReader, this.restorer});

  final ApiClient _api;
  final SessionReader? sessionReader;
  final SessionRestorer? restorer;

  Future<AuthSession> login(String email, String password) => _authenticate(
    '/auth/login',
    data: {'email': email, 'password': password},
  );

  Future<AuthSession> register({
    required String displayName,
    required String email,
    required String password,
  }) => _authenticate(
    '/auth/register',
    data: {'displayName': displayName, 'email': email, 'password': password},
  );

  Future<AuthSession> refresh(String refreshToken) =>
      _authenticate('/auth/refresh', data: {'refreshToken': refreshToken});

  Future<void> logout() async {
    try {
      await _api.post('/auth/logout');
    } on ApiException catch (error) {
      if (error.statusCode == 401 || error.statusCode == 404) return;
      rethrow;
    }
  }

  Future<AuthSession> restoreSession() async {
    final restore = restorer;
    if (restore != null) await restore();
    final reader = sessionReader;
    if (reader != null) return reader();
    return const AuthSession(status: AuthStatus.anonymous);
  }

  Future<AuthSession> _authenticate(String path, {Object? data}) async {
    final body = await _api.post(path, data: data);
    return parseAuthSession(body);
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.watch(apiClientProvider),
    sessionReader: () => ref.read(sessionProvider),
    restorer: () => ref.read(sessionProvider.notifier).restore(),
  );
});
