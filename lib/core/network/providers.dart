import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_client.dart';
import '../state/app_providers.dart';
import '../../app/config.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient(baseUrl: ref.watch(apiBaseUrlProvider));
  client.setAccessToken(ref.read(sessionProvider).accessToken);
  ref.listen<AuthSession>(sessionProvider, (_, next) {
    client.setAccessToken(next.accessToken);
  });
  return client;
});
