import 'package:flutter_test/flutter_test.dart';
import 'package:tango/core/network/api_client.dart';

void main() {
  const config = RetryConfig(
    maxRetries: 2,
    baseDelay: Duration(milliseconds: 100),
    maxDelay: Duration(seconds: 1),
  );

  group('RetryPolicy', () {
    test('only GET is idempotent, regardless of case', () {
      expect(RetryPolicy.isIdempotent('GET'), isTrue);
      expect(RetryPolicy.isIdempotent('get'), isTrue);
      expect(RetryPolicy.isIdempotent('POST'), isFalse);
      expect(RetryPolicy.isIdempotent('PATCH'), isFalse);
      expect(RetryPolicy.isIdempotent('DELETE'), isFalse);
    });

    test('GET retries network and server errors', () {
      expect(
        RetryPolicy.shouldRetry(
          method: 'GET',
          attempt: 0,
          maxRetries: config.maxRetries,
          cause: RetryCause.network,
        ),
        isTrue,
      );
      expect(
        RetryPolicy.shouldRetry(
          method: 'GET',
          attempt: 1,
          maxRetries: config.maxRetries,
          cause: RetryCause.serverError,
        ),
        isTrue,
      );
    });

    test('mutating methods are never retried', () {
      for (final method in ['POST', 'PATCH', 'DELETE']) {
        expect(
          RetryPolicy.shouldRetry(
            method: method,
            attempt: 0,
            maxRetries: config.maxRetries,
            cause: RetryCause.network,
          ),
          isFalse,
        );
      }
    });

    test('client errors and other causes are not retried', () {
      expect(
        RetryPolicy.shouldRetry(
          method: 'GET',
          attempt: 0,
          maxRetries: config.maxRetries,
          cause: RetryCause.none,
        ),
        isFalse,
      );
    });

    test('retries stop once maxRetries attempts were used', () {
      expect(
        RetryPolicy.shouldRetry(
          method: 'GET',
          attempt: 2,
          maxRetries: config.maxRetries,
          cause: RetryCause.serverError,
        ),
        isFalse,
      );
    });

    test('backoff doubles each attempt and is capped', () {
      Duration backoff(int attempt) => RetryPolicy.backoffFor(
        attempt: attempt,
        baseDelay: config.baseDelay,
        maxDelay: config.maxDelay,
      );

      expect(backoff(0), const Duration(milliseconds: 100));
      expect(backoff(1), const Duration(milliseconds: 200));
      expect(backoff(2), const Duration(milliseconds: 400));
      expect(backoff(10), const Duration(seconds: 1));
    });
  });

  group('ApiListParser', () {
    test('parses rows and metadata from a list envelope', () {
      final envelope = ApiListParser.parse<Map<String, dynamic>>({
        'data': [
          {'id': '1'},
          {'id': '2'},
        ],
        'meta': {'page': '2', 'per_page': 10, 'total': 25, 'nextPage': 3},
      }, (json) => json);

      expect(envelope.items, hasLength(2));
      expect(envelope.items.first['id'], '1');
      expect(envelope.meta.page, 2);
      expect(envelope.meta.perPage, 10);
      expect(envelope.meta.total, 25);
      expect(envelope.meta.extra['nextPage'], 3);
    });

    test('unwraps nested data and tolerates missing metadata', () {
      final envelope = ApiListParser.parse<String>({
        'data': {
          'items': [
            {'name': 'a'},
          ],
        },
      }, (json) => json['name'] as String);

      expect(envelope.items, ['a']);
      expect(envelope.meta, const ApiMeta());
    });
  });
}
