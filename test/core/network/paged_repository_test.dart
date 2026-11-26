import 'package:flutter_test/flutter_test.dart';
import 'package:tango/core/data/paged_repository.dart';
import 'package:tango/core/data/ttl_cache.dart';

class _FakeSource implements PagedDataSource<int> {
  _FakeSource(this._pages);

  final Map<String?, Page<int>> _pages;
  final List<PageRequest> requests = <PageRequest>[];

  @override
  Future<Page<int>> load(PageRequest request) async {
    requests.add(request);
    return _pages[request.cursor] ?? const Page<int>(items: [], hasMore: false);
  }
}

void main() {
  Page<int> page(List<int> items, String? cursor, bool hasMore) =>
      Page<int>(items: items, hasMore: hasMore, nextCursor: cursor);

  test('PageRequest builds query parameters from filters and cursor', () {
    const request = PageRequest(
      cursor: 'abc',
      limit: 10,
      filters: {'category': 'Flutter'},
    );

    expect(request.toQueryParameters(), {
      'category': 'Flutter',
      'limit': 10,
      'cursor': 'abc',
    });
  });

  test('keyFor produces a stable cache key regardless of filter order', () {
    final repository = PagedRepository<int>(_FakeSource({}));
    final a = repository.keyFor(const PageRequest(filters: {'x': 1, 'y': 2}));
    final b = repository.keyFor(const PageRequest(filters: {'y': 2, 'x': 1}));

    expect(a, b);
  });

  test('loadPage caches repeated requests', () async {
    final source = _FakeSource({
      null: page([1, 2], null, false),
    });
    final repository = PagedRepository<int>(source);

    final first = await repository.loadPage(const PageRequest());
    final second = await repository.loadPage(const PageRequest());

    expect(first.items, [1, 2]);
    expect(second.items, [1, 2]);
    expect(source.requests, hasLength(1));
  });

  test('loadAll follows cursors until the last page', () async {
    final source = _FakeSource({
      null: page([1, 2], 'p2', true),
      'p2': page([3, 4], null, false),
    });
    final repository = PagedRepository<int>(source);

    final items = await repository.loadAll();

    expect(items, [1, 2, 3, 4]);
    expect(source.requests, hasLength(2));
    expect(source.requests.last.cursor, 'p2');
  });

  test('loadAll stops at maxPages', () async {
    final source = _FakeSource({
      null: page([1], 'p2', true),
      'p2': page([2], 'p3', true),
      'p3': page([3], 'p4', true),
    });
    final repository = PagedRepository<int>(source);

    final items = await repository.loadAll(maxPages: 2);

    expect(items, [1, 2]);
  });

  test('invalidate clears cached pages', () async {
    final source = _FakeSource({
      null: page([1], null, false),
    });
    final repository = PagedRepository<int>(source);

    await repository.loadPage(const PageRequest());
    repository.invalidate();
    await repository.loadPage(const PageRequest());

    expect(source.requests, hasLength(2));
  });

  test(
    'a shared cache lets the controller and repository agree on data',
    () async {
      final source = _FakeSource({
        null: page([9], null, false),
      });
      final cache = TtlCache<Page<int>>();
      final repository = PagedRepository<int>(source, cache: cache);

      final controller = PagedListController<int>(repository);
      await controller.loadFirst();

      expect(controller.state.items, [9]);
      expect(controller.state.status, PagedStatus.ready);
      expect(cache.length, 1);
    },
  );
}
