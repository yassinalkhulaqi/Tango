import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../localization/app_locale.dart';
import '../localization/locale_controller.dart';

class AuthSession {
  final String? accessToken;
  final String? refreshToken;
  final String? userId;

  const AuthSession({this.accessToken, this.refreshToken, this.userId});

  bool get isAuthenticated => accessToken != null;

  AuthSession copyWith({
    String? accessToken,
    String? refreshToken,
    String? userId,
    bool clear = false,
  }) {
    if (clear) return const AuthSession();
    return AuthSession(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      userId: userId ?? this.userId,
    );
  }
}

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
});

final sessionProvider = StateNotifierProvider<SessionNotifier, AuthSession>((
  ref,
) {
  return SessionNotifier(ref.watch(secureStorageProvider));
});

class SessionNotifier extends StateNotifier<AuthSession> {
  SessionNotifier(this._storage) : super(const AuthSession()) {
    _restore();
  }

  final FlutterSecureStorage _storage;

  Future<void> _restore() async {
    try {
      final values = await _storage.readAll();
      final access = values['accessToken'];
      if (access != null && access.isNotEmpty) {
        state = AuthSession(
          accessToken: access,
          refreshToken: values['refreshToken'],
          userId: values['userId'],
        );
      }
    } catch (_) {
      state = const AuthSession();
    }
  }

  Future<void> signIn({
    required String accessToken,
    required String refreshToken,
    String? userId,
  }) async {
    state = AuthSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      userId: userId,
    );
    await _storage.write(key: 'accessToken', value: accessToken);
    await _storage.write(key: 'refreshToken', value: refreshToken);
    if (userId != null) {
      await _storage.write(key: 'userId', value: userId);
    }
  }

  Future<void> signOut() async {
    state = const AuthSession();
    await Future.wait([
      _storage.delete(key: 'accessToken'),
      _storage.delete(key: 'refreshToken'),
      _storage.delete(key: 'userId'),
    ]);
  }
}

final localeControllerProvider = ChangeNotifierProvider<LocaleController>((
  ref,
) {
  return LocaleController(AppLocale.en);
});
