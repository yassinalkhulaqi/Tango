import 'package:flutter/material.dart';

/// Validation result for a single form field.
class FieldValidation {
  final String? error;
  const FieldValidation.valid() : error = null;
  const FieldValidation.invalid(this.error);
  bool get isValid => error == null;
}

/// Validators shared by auth forms. Pass in localized error messages so all
/// copy comes from the catalogue.
class AuthValidators {
  const AuthValidators._();

  static FieldValidation email(String value, String emptyMsg, String invalidMsg) {
    if (value.trim().isEmpty) return FieldValidation.invalid(emptyMsg);
    final email = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return email.hasMatch(value.trim())
        ? const FieldValidation.valid()
        : FieldValidation.invalid(invalidMsg);
  }

  static FieldValidation password(String value, String emptyMsg, String shortMsg) {
    if (value.isEmpty) return FieldValidation.invalid(emptyMsg);
    if (value.length < 8) return FieldValidation.invalid(shortMsg);
    return const FieldValidation.valid();
  }

  static FieldValidation confirm(
    String value,
    String password,
    String emptyMsg,
    String mismatchMsg,
  ) {
    if (value.isEmpty) return FieldValidation.invalid(emptyMsg);
    return value == password
        ? const FieldValidation.valid()
        : FieldValidation.invalid(mismatchMsg);
  }
}
