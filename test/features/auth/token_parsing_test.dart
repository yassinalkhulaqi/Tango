import 'package:flutter_test/flutter_test.dart';
import 'package:tango/core/network/api_exception.dart';
import 'package:tango/core/state/app_providers.dart';
import 'package:tango/features/authentication/data/auth_repository.dart';

void main() {
  group('parseAuthSession', () {
    test('parses a camelCase data envelope', () {
      final session = parseAuthSession({
        'data': {
          'accessToken': 'a1',
          'refreshToken': 'r1',
          'user': {'id': 'u1'},
        },
      });

      expect(session.accessToken, 'a1');
      expect(session.refreshToken, 'r1');
      expect(session.userId, 'u1');
      expect(session.status, AuthStatus.authenticated);
      expect(session.isAuthenticated, isTrue);
    });

    test('parses nested tokens with snake_case keys', () {
      final session = parseAuthSession({
        'data': {
          'tokens': {'access_token': 'a2', 'refresh_token': 'r2'},
          'user': {'_id': 'u2'},
        },
      });

      expect(session.accessToken, 'a2');
      expect(session.refreshToken, 'r2');
      expect(session.userId, 'u2');
    });

    test('parses flat top level tokens', () {
      final session = parseAuthSession({
        'access_token': 'a3',
        'refresh_token': 'r3',
        'user_id': 'u3',
      });

      expect(session.accessToken, 'a3');
      expect(session.refreshToken, 'r3');
      expect(session.userId, 'u3');
    });

    test('parses a list-wrapped data envelope', () {
      final session = parseAuthSession({
        'data': [
          {'accessToken': 'a4', 'userId': 'u4'},
        ],
      });

      expect(session.accessToken, 'a4');
      expect(session.userId, 'u4');
      expect(session.refreshToken, isNull);
    });

    test('skips empty token values', () {
      final session = parseAuthSession({
        'accessToken': '',
        'access_token': 'a5',
      });

      expect(session.accessToken, 'a5');
    });

    test('throws missing_token when no access token is present', () {
      expect(
        () => parseAuthSession({
          'data': {
            'user': {'id': 'u'},
          },
        }),
        throwsA(
          isA<ApiException>().having(
            (error) => error.code,
            'code',
            'missing_token',
          ),
        ),
      );
    });
  });
}
