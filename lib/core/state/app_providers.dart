import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../localization/app_locale.dart';
import '../localization/locale_controller.dart';

enum AuthStatus { unknown, authenticated, anonymous }

class AuthSession {
  const AuthSession({
    this.accessToken,
    this.refreshToken,
    this.userId,
    this.status = AuthStatus.unknown,
  });

  final String? accessToken;
  final String? refreshToken;
  final String? userId;
  final AuthStatus status;

  bool get isAuthenticated =>
      status == AuthStatus.authenticated &&
      accessToken != null &&
      accessToken!.isNotEmpty;

  static AuthStatus resolveStatus(AuthStatus current, String? accessToken) {
    if (accessToken != null && accessToken.isNotEmpty) {
      return AuthStatus.authenticated;
    }
    return current == AuthStatus.unknown
        ? AuthStatus.unknown
        : AuthStatus.anonymous;
  }

  AuthSession copyWith({
    String? accessToken,
    String? refreshToken,
    String? userId,
    AuthStatus? status,
    bool clear = false,
  }) {
    if (clear) return const AuthSession(status: AuthStatus.anonymous);
    final nextAccessToken = accessToken ?? this.accessToken;
    return AuthSession(
      accessToken: nextAccessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      userId: userId ?? this.userId,
      status: status ?? resolveStatus(this.status, nextAccessToken),
    );
  }
}

typedef SessionRevoker = Future<void> Function(String accessToken);

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
});

final sessionProvider = StateNotifierProvider<SessionNotifier, AuthSession>((
  ref,
) {
  final notifier = SessionNotifier(ref.watch(secureStorageProvider));
  unawaited(notifier.restore());
  return notifier;
});

class SessionNotifier extends StateNotifier<AuthSession> {
  SessionNotifier(this._storage, {this._revoker})
    : super(const AuthSession(status: AuthStatus.unknown));

  static const String accessTokenKey = 'accessToken';
  static const String refreshTokenKey = 'refreshToken';
  static const String userIdKey = 'userId';

  final FlutterSecureStorage _storage;
  SessionRevoker? _revoker;
  Future<void>? _restoreFuture;
  bool _isRestoring = false;

  bool get isRestoring => _isRestoring;

  void setRevoker(SessionRevoker revoker) => _revoker = revoker;

  Future<void> restore() {
    final pending = _restoreFuture;
    if (pending != null) return pending;
    _isRestoring = true;
    final tracked = _readStoredSession().whenComplete(() {
      _isRestoring = false;
      _restoreFuture = null;
    });
    _restoreFuture = tracked;
    return tracked;
  }

  Future<void> _readStoredSession() async {
    try {
      final values = await _storage.readAll();
      final access = values[accessTokenKey];
      if (access != null && access.isNotEmpty) {
        state = AuthSession(
          accessToken: access,
          refreshToken: values[refreshTokenKey],
          userId: values[userIdKey],
          status: AuthStatus.authenticated,
        );
      } else {
        state = const AuthSession(status: AuthStatus.anonymous);
      }
    } catch (_) {
      state = const AuthSession(status: AuthStatus.anonymous);
    }
  }

  Future<void> updateTokens({
    required String accessToken,
    String? refreshToken,
    String? userId,
  }) async {
    state = state.copyWith(
      accessToken: accessToken,
      refreshToken: refreshToken,
      userId: userId,
      status: AuthStatus.authenticated,
    );
    await _storage.write(key: accessTokenKey, value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: refreshTokenKey, value: refreshToken);
    }
    if (userId != null) {
      await _storage.write(key: userIdKey, value: userId);
    }
  }

  Future<void> signIn({
    required String accessToken,
    required String refreshToken,
    String? userId,
  }) => updateTokens(
    accessToken: accessToken,
    refreshToken: refreshToken,
    userId: userId,
  );

  Future<void> signOut() async {
    final token = state.accessToken;
    final revoker = _revoker;
    state = const AuthSession(status: AuthStatus.anonymous);
    try {
      await Future.wait([
        _storage.delete(key: accessTokenKey),
        _storage.delete(key: refreshTokenKey),
        _storage.delete(key: userIdKey),
      ]);
    } catch (_) {
      state = const AuthSession(status: AuthStatus.anonymous);
    }
    if (revoker != null && token != null && token.isNotEmpty) {
      try {
        await revoker(token);
      } catch (_) {
        return;
      }
    }
  }
}

final localeControllerProvider = ChangeNotifierProvider<LocaleController>((
  ref,
) {
  return LocaleController(AppLocale.en);
});
