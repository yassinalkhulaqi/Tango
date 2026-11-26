import 'package:flutter/material.dart';
import './app_locale.dart';

/// Holds the active locale and notifies the widget tree on change.
///
/// The locale is also exposed to the router through [routeSegment], which is
/// always a language-only tag so URLs stay short and stable.
class LocaleController extends ChangeNotifier {
  LocaleController([AppLocale initial = AppLocale.en]) : _locale = initial;

  AppLocale _locale;

  AppLocale get locale => _locale;
  String get code => _locale.code;
  String get routeSegment => _locale.code;
  TextDirection get direction => _locale.direction;
  bool get isRtl => _locale.isRtl;

  bool setLocale(AppLocale next) {
    if (next == _locale) return false;
    _locale = next;
    notifyListeners();
    return true;
  }

  bool setCode(String code) => setLocale(AppLocale.fromCode(code));

  void reset() => setLocale(AppLocale.en);

  @override
  String toString() => 'LocaleController($code)';
}

/// Inherited widget that makes [LocaleController] available to descendants.
class LocaleScope extends InheritedNotifier<LocaleController> {
  const LocaleScope({
    super.key,
    required LocaleController controller,
    required super.child,
  }) : super(notifier: controller);

  static LocaleController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<LocaleScope>();
    return scope?.notifier ?? LocaleController();
  }

  static LocaleController? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LocaleScope>()?.notifier;
}
