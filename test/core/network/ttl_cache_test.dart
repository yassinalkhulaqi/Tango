import 'package:flutter_test/flutter_test.dart';
import 'package:tango/core/data/ttl_cache.dart';

void main() {
  test('stores and retrieves a value before the TTL expires', () {
    var now = DateTime(2026, 1, 1);
    final cache = TtlCache<int>(clock: () => now);

    cache.set('a', 7, ttl: const Duration(seconds: 10));

    expect(cache.get('a'), 7);
    expect(cache.containsKey('a'), isTrue);

    now = now.add(const Duration(seconds: 9));
    expect(cache.get('a'), 7);
  });

  test('evicts expired values and reports them as absent', () {
    var now = DateTime(2026, 1, 1);
    final cache = TtlCache<int>(clock: () => now);

    cache.set('a', 1, ttl: const Duration(seconds: 5));
    now = now.add(const Duration(seconds: 5));

    expect(cache.get('a'), isNull);
    expect(cache.containsKey('a'), isFalse);
    expect(cache.length, 0);
  });

  test('getOrLoad caches the loader result', () async {
    var calls = 0;
    final cache = TtlCache<String>();

    Future<String> loader() async {
      calls++;
      return 'value';
    }

    expect(await cache.getOrLoad(key: 'k', loader: loader), 'value');
    expect(await cache.getOrLoad(key: 'k', loader: loader), 'value');
    expect(calls, 1);
  });

  test('getOrLoad de-duplicates concurrent loads', () async {
    final cache = TtlCache<String>();
    var calls = 0;
    Future<String> loader() async {
      calls++;
      await Future<void>.delayed(const Duration(milliseconds: 10));
      return 'shared';
    }

    final results = await Future.wait([
      cache.getOrLoad(key: 'k', loader: loader),
      cache.getOrLoad(key: 'k', loader: loader),
      cache.getOrLoad(key: 'k', loader: loader),
    ]);

    expect(results, ['shared', 'shared', 'shared']);
    expect(calls, 1);
  });

  test('forceRefresh bypasses and replaces the cached value', () async {
    var calls = 0;
    final cache = TtlCache<int>();
    Future<int> loader() async => ++calls;

    expect(await cache.getOrLoad(key: 'k', loader: loader), 1);
    expect(
      await cache.getOrLoad(key: 'k', loader: loader, forceRefresh: true),
      2,
    );
    expect(cache.get('k'), 2);
  });

  test('a failed load is not cached and can be retried', () async {
    final cache = TtlCache<int>();
    var calls = 0;
    Future<int> loader() async {
      calls++;
      if (calls == 1) throw StateError('offline');
      return 42;
    }

    expect(cache.getOrLoad(key: 'k', loader: loader), throwsStateError);
    await Future<void>.delayed(const Duration(milliseconds: 1));
    expect(await cache.getOrLoad(key: 'k', loader: loader), 42);
  });

  test('invalidation removes only matching keys', () {
    final cache = TtlCache<int>();
    cache.set('courses|1', 1);
    cache.set('courses|2', 2);
    cache.set('quiz|1', 3);

    cache.invalidateWhere((key) => key.startsWith('courses'));

    expect(cache.get('courses|1'), isNull);
    expect(cache.get('courses|2'), isNull);
    expect(cache.get('quiz|1'), 3);
  });

  test('maxEntries evicts the oldest entry', () {
    var now = DateTime(2026, 1, 1);
    final cache = TtlCache<int>(maxEntries: 2, clock: () => now);
    cache.set('a', 1);
    now = now.add(const Duration(seconds: 1));
    cache.set('b', 2);
    now = now.add(const Duration(seconds: 1));
    cache.set('c', 3);

    expect(cache.get('a'), isNull);
    expect(cache.get('b'), 2);
    expect(cache.get('c'), 3);
  });
}
