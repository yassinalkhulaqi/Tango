import 'package:flutter_test/flutter_test.dart';
import 'package:tango/core/state/app_providers.dart';

void main() {
  group('AuthSession status transitions', () {
    test('a fresh session is unknown and not authenticated', () {
      const session = AuthSession();

      expect(session.status, AuthStatus.unknown);
      expect(session.isAuthenticated, isFalse);
      expect(
        AuthSession.resolveStatus(AuthStatus.unknown, null),
        AuthStatus.unknown,
      );
    });

    test('adding a token promotes an unknown session to authenticated', () {
      final session = const AuthSession().copyWith(
        accessToken: 'a1',
        refreshToken: 'r1',
        userId: 'u1',
      );

      expect(session.status, AuthStatus.authenticated);
      expect(session.isAuthenticated, isTrue);
      expect(session.refreshToken, 'r1');
      expect(session.userId, 'u1');
    });

    test('clearing a session returns an anonymous session', () {
      final anonymous = AuthSession(
        accessToken: 'a1',
        status: AuthStatus.authenticated,
      ).copyWith(clear: true);

      expect(anonymous.status, AuthStatus.anonymous);
      expect(anonymous.accessToken, isNull);
      expect(anonymous.isAuthenticated, isFalse);
    });

    test('resolveStatus derives the expected transitions', () {
      expect(
        AuthSession.resolveStatus(AuthStatus.anonymous, 'a1'),
        AuthStatus.authenticated,
      );
      expect(
        AuthSession.resolveStatus(AuthStatus.authenticated, null),
        AuthStatus.anonymous,
      );
      expect(
        AuthSession.resolveStatus(AuthStatus.anonymous, ''),
        AuthStatus.anonymous,
      );
    });

    test('an explicit status override wins over the derived status', () {
      final session = const AuthSession().copyWith(
        accessToken: 'a1',
        status: AuthStatus.anonymous,
      );

      expect(session.status, AuthStatus.anonymous);
      expect(session.isAuthenticated, isFalse);
    });

    test('an empty access token is never authenticated', () {
      final session = AuthSession(
        accessToken: 'a1',
        status: AuthStatus.authenticated,
      ).copyWith(accessToken: '');

      expect(session.status, AuthStatus.anonymous);
      expect(session.isAuthenticated, isFalse);
    });
  });
}
