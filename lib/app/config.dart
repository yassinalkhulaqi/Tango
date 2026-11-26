import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'flavors.dart';

final apiBaseUrlProvider = Provider<String>((ref) {
  return AppEnvironment.apiBaseUrl;
});

final appNameProvider = Provider<String>((ref) {
  return AppEnvironment.appName;
});
