import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_client.dart';
import 'api_exception.dart';
import '../state/app_providers.dart';
import '../../app/config.dart';
import '../../features/authentication/data/auth_repository.dart';

final authRefreshDioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: ref.watch(apiBaseUrlProvider),
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  );
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient(baseUrl: ref.watch(apiBaseUrlProvider));
  client.setAccessToken(ref.read(sessionProvider).accessToken);
  ref.listen<AuthSession>(sessionProvider, (_, next) {
    client.setAccessToken(next.accessToken);
  });

  final refreshDio = ref.read(authRefreshDioProvider);
  client.setTokenRefresher(() async {
    final session = ref.read(sessionProvider);
    final refreshToken = session.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) return null;
    try {
      final response = await refreshDio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );
      final body = response.data;
      if (body is! Map<dynamic, dynamic>) return null;
      final tokens = parseAuthSession(Map<String, dynamic>.from(body));
      await ref
          .read(sessionProvider.notifier)
          .updateTokens(
            accessToken: tokens.accessToken!,
            refreshToken: tokens.refreshToken ?? refreshToken,
            userId: tokens.userId ?? session.userId,
          );
      return tokens.accessToken;
    } on DioException {
      return null;
    } on ApiException {
      return null;
    }
  });

  ref.read(sessionProvider.notifier).setRevoker((accessToken) async {
    try {
      await refreshDio.post<void>(
        '/auth/logout',
        data: {'accessToken': accessToken},
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
    } on DioException {
      return;
    }
  });

  return client;
});
