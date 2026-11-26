import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/providers.dart';
import '../../../core/state/app_providers.dart';

class AuthRepository {
  AuthRepository(this._api);

  final ApiClient _api;

  Future<AuthSession> login(String email, String password) async {
    final body = await _api.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    return _sessionFrom(body);
  }

  Future<AuthSession> register({
    required String displayName,
    required String email,
    required String password,
  }) async {
    final body = await _api.post(
      '/auth/register',
      data: {'displayName': displayName, 'email': email, 'password': password},
    );
    return _sessionFrom(body);
  }

  Future<AuthSession> refresh(String refreshToken) async {
    final body = await _api.post(
      '/auth/refresh',
      data: {'refreshToken': refreshToken},
    );
    return _sessionFrom(body);
  }

  Future<void> logout() => _api.post('/auth/logout');

  AuthSession _sessionFrom(Map<String, dynamic> body) {
    final raw = body['data'];
    final data = raw is Map ? Map<String, dynamic>.from(raw) : body;
    final tokens = data['tokens'] is Map
        ? Map<String, dynamic>.from(data['tokens'] as Map)
        : data;
    final access = tokens['accessToken'] ?? data['access_token'];
    if (access == null) {
      throw const ApiException(
        code: 'missing_token',
        message: 'The server did not return an access token.',
      );
    }
    final user = data['user'] is Map
        ? Map<String, dynamic>.from(data['user'] as Map)
        : null;
    return AuthSession(
      accessToken: access.toString(),
      refreshToken: tokens['refreshToken']?.toString(),
      userId: (user?['id'] ?? data['userId'])?.toString(),
    );
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(apiClientProvider));
});
