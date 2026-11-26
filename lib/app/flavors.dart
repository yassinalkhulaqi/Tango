enum AppFlavor {
  dev('dev', 'http://10.0.2.2:3000/api/v1', 'CodeBro Dev'),
  staging(
    'staging',
    'https://api.staging.codebro.dev/api/v1',
    'CodeBro Staging',
  ),
  prod('prod', 'https://api.codebro.dev/api/v1', 'CodeBro');

  const AppFlavor(this.value, this.apiBaseUrl, this.displayName);

  final String value;
  final String apiBaseUrl;
  final String displayName;

  static AppFlavor from(String? value) {
    return AppFlavor.values.firstWhere(
      (flavor) => flavor.value == value,
      orElse: () => AppFlavor.dev,
    );
  }
}

class AppEnvironment {
  const AppEnvironment._();

  static const String flavorName = String.fromEnvironment(
    'FLAVOR',
    defaultValue: 'dev',
  );

  static AppFlavor get flavor => AppFlavor.from(flavorName);

  static String get apiBaseUrl =>
      const String.fromEnvironment('API_BASE_URL', defaultValue: '').isEmpty
      ? flavor.apiBaseUrl
      : const String.fromEnvironment('API_BASE_URL');

  static String get appName => flavor.displayName;

  static bool get isProduction => flavor == AppFlavor.prod;
}
