import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/localization/app_localizations.dart';
import '../core/localization/app_locale.dart';
import '../core/localization/locale_controller.dart';
import '../core/state/app_providers.dart';
import 'router.dart';
import 'theme.dart';

class CodeBroApp extends ConsumerWidget {
  const CodeBroApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final localeController = ref.watch(localeControllerProvider);
    return ListenableBuilder(
      listenable: localeController,
      builder: (context, _) {
        return LocaleScope(
          controller: localeController,
          child: Directionality(
            textDirection: localeController.direction,
            child: MaterialApp.router(
              title: 'CodeBro',
              debugShowCheckedModeBanner: false,
              routerConfig: router,
              theme: buildAppTheme(),
              locale: Locale(localeController.code),
              supportedLocales: AppLocale.supportedLocales,
              localizationsDelegates: AppLocalizations.delegates,
            ),
          ),
        );
      },
    );
  }
}
