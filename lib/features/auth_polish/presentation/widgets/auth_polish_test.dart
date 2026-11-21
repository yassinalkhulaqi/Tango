import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tango/core/theme/app_colors.dart';
import 'package:tango/features/auth_polish/domain/auth_validators.dart';
import 'package:tango/features/auth_polish/presentation/pages/polished_login_page.dart';
import 'package:tango/features/auth_polish/presentation/widgets/polished_auth_fields.dart';

const messages = {
  'emailLabel': 'Email', 'emailHint': 'dev@example.com',
  'emailEmpty': 'Email is required', 'emailInvalid': 'Enter a valid email',
  'passwordLabel': 'Password', 'passwordEmpty': 'Password is required',
  'passwordShort': 'At least 8 characters', 'login': 'Login',
};

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: Padding(padding: const EdgeInsets.all(16), child: child)));

void main() {
  group('AuthValidators', () {
    test('valid email passes', () {
      expect(AuthValidators.email('a@b.com', 'e', 'i').isValid, isTrue);
    });
    test('invalid email fails', () {
      expect(AuthValidators.email('nope', 'e', 'i').error, 'i');
    });
    test('empty email fails', () {
      expect(AuthValidators.email('', 'e', 'i').error, 'e');
    });
    test('short password fails', () {
      expect(AuthValidators.password('123', 'e', 's').error, 's');
    });
    test('valid password passes', () {
      expect(AuthValidators.password('12345678', 'e', 's').isValid, isTrue);
    });
    test('confirm mismatch fails', () {
      expect(AuthValidators.confirm('a', 'b', 'e', 'm').error, 'm');
    });
  });

  group('PolishedLoginForm', () {
    testWidgets('shows validation errors on empty submit', (tester) async {
      await tester.pumpWidget(_wrap(PolishedLoginForm(messages: messages, onSuccess: () {})));
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      expect(find.text('Email is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('calls onSuccess with valid input', (tester) async {
      var success = false;
      await tester.pumpWidget(_wrap(PolishedLoginForm(messages: messages, onSuccess: () => success = true)));
      await tester.enterText(find.byType(TextField).at(0), 'dev@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      expect(success, isTrue);
    });
  });

  group('PolishedPasswordField', () {
    testWidgets('toggles visibility', (tester) async {
      await tester.pumpWidget(_wrap(PolishedPasswordField(
        controller: TextEditingController(), label: 'Password', hint: '***',
      )));
      expect(find.byIcon(Icons.visibility_off_rounded), findsOneWidget);
      await tester.tap(find.byIcon(Icons.visibility_off_rounded));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.visibility_rounded), findsOneWidget);
    });
  });
}
