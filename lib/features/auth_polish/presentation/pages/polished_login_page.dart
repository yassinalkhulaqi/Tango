import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../widgets/polished_auth_fields.dart';
import '../../domain/auth_validators.dart';

/// Polished login form with inline validation and localized messages passed
/// in by the caller. Fields mirror for RTL locales.
class PolishedLoginForm extends StatefulWidget {
  final bool rtl;
  final Map<String, String> messages;
  final VoidCallback onSuccess;

  const PolishedLoginForm({
    super.key,
    this.rtl = false,
    required this.messages,
    required this.onSuccess,
  });

  @override
  State<PolishedLoginForm> createState() => _PolishedLoginFormState();
}

class _PolishedLoginFormState extends State<PolishedLoginForm> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    final emailResult = AuthValidators.email(
      _email.text,
      widget.messages['emailEmpty'] ?? 'Email is required',
      widget.messages['emailInvalid'] ?? 'Enter a valid email',
    );
    final passwordResult = AuthValidators.password(
      _password.text,
      widget.messages['passwordEmpty'] ?? 'Password is required',
      widget.messages['passwordShort'] ?? 'At least 8 characters',
    );
    setState(() {
      _emailError = emailResult.error;
      _passwordError = passwordResult.error;
    });
    if (emailResult.isValid && passwordResult.isValid) widget.onSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PolishedEmailField(
          controller: _email,
          label: widget.messages['emailLabel'] ?? 'Email',
          hint: widget.messages['emailHint'] ?? 'dev@example.com',
          error: _emailError,
          rtl: widget.rtl,
        ),
        const SizedBox(height: AppSpacing.lg),
        PolishedPasswordField(
          controller: _password,
          label: widget.messages['passwordLabel'] ?? 'Password',
          hint: '••••••••',
          error: _passwordError,
          rtl: widget.rtl,
        ),
        const SizedBox(height: AppSpacing.xxl),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: Text(widget.messages['login'] ?? 'Login'),
        ),
      ],
    );
  }
}
