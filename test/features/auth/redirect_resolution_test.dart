import 'package:flutter_test/flutter_test.dart';
import 'package:tango/app/router.dart';
import 'package:tango/core/state/app_providers.dart';

void main() {
  group('AuthRedirect.resolve', () {
    test('an unknown session does not redirect during restore', () {
      expect(
        AuthRedirect.resolve(status: AuthStatus.unknown, location: '/courses'),
        isNull,
      );
    });

    test('anonymous users are sent to login with their intended location', () {
      expect(
        AuthRedirect.resolve(
          status: AuthStatus.anonymous,
          location: '/courses',
        ),
        '/login?from=%2Fcourses',
      );
    });

    test('anonymous users can reach auth pages and onboarding', () {
      for (final location in ['/', '/login', '/register', '/forgot-password']) {
        expect(
          AuthRedirect.resolve(
            status: AuthStatus.anonymous,
            location: location,
          ),
          isNull,
        );
      }
    });

    test('authenticated users return to the requested location', () {
      expect(
        AuthRedirect.resolve(
          status: AuthStatus.authenticated,
          location: '/login',
          from: '/courses',
        ),
        '/courses',
      );
    });

    test('authenticated users fall back to home without a safe location', () {
      expect(
        AuthRedirect.resolve(
          status: AuthStatus.authenticated,
          location: '/register',
        ),
        '/home',
      );
      expect(
        AuthRedirect.resolve(status: AuthStatus.authenticated, location: '/'),
        '/home',
      );
    });

    test('no redirect is issued when already at the destination', () {
      expect(
        AuthRedirect.resolve(
          status: AuthStatus.authenticated,
          location: '/login',
          from: '/login',
        ),
        '/home',
      );
      expect(
        AuthRedirect.resolve(
          status: AuthStatus.authenticated,
          location: '/courses',
        ),
        isNull,
      );
    });
  });

  group('AuthRedirect.safeReturnPath', () {
    test('accepts internal paths', () {
      expect(
        AuthRedirect.safeReturnPath('/courses/1?tab=x'),
        '/courses/1?tab=x',
      );
    });

    test('rejects unsafe or auth paths', () {
      for (final path in [
        null,
        '',
        'courses',
        '//evil.com',
        '/',
        '/login',
        '/register',
        '/forgot-password',
      ]) {
        expect(AuthRedirect.safeReturnPath(path), isNull);
      }
    });
  });
}
