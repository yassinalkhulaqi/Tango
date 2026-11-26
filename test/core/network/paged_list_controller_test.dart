import 'package:flutter_test/flutter_test.dart';
import 'package:tango/core/data/paged_repository.dart';

class _ControllerSource implements PagedDataSource<int> {
  _ControllerSource(this._pages);

  final Map<String?, Page<int>> _pages;
  int calls = 0;
  PageRequest? lastRequest;

  @override
  Future<Page<int>> load(PageRequest request) async {
    calls++;
    lastRequest = request;
    return _pages[request.cursor] ?? const Page<int>(items: [], hasMore: false);
  }
}

void main() {
  Page<int> page(List<int> items, String? cursor, {bool hasMore = false}) =>
      Page<int>(items: items, nextCursor: cursor, hasMore: hasMore);

  test('loadFirst populates items and ready status', () async {
    final source = _ControllerSource({
      null: page([1, 2], null),
    });
    final controller = PagedListController<int>(PagedRepository<int>(source));

    await controller.loadFirst();

    expect(controller.state.status, PagedStatus.ready);
    expect(controller.state.items, [1, 2]);
    expect(controller.state.hasMore, isFalse);
  });

  test('loadMore appends the next page', () async {
    final source = _ControllerSource({
      null: page([1], 'p2', hasMore: true),
      'p2': page([2], null),
    });
    final controller = PagedListController<int>(PagedRepository<int>(source));

    await controller.loadFirst();
    await controller.loadMore();

    expect(controller.state.items, [1, 2]);
    expect(controller.state.hasMore, isFalse);
    expect(source.calls, 2);
  });

  test('loadMore is a no-op when there is no next cursor', () async {
    final source = _ControllerSource({
      null: page([1], null),
    });
    final controller = PagedListController<int>(PagedRepository<int>(source));

    await controller.loadFirst();
    await controller.loadMore();

    expect(source.calls, 1);
  });

  test('loadMore is a no-op while another load is in flight', () async {
    final source = _ControllerSource({
      null: page([1], 'p2', hasMore: true),
      'p2': page([2], null),
    });
    final controller = PagedListController<int>(PagedRepository<int>(source));

    final first = controller.loadFirst();
    await controller.loadMore();
    await first;

    expect(source.calls, 1);
  });

  test(
    'failures expose a message without discarding unrelated state',
    () async {
      final controller = PagedListController<int>(
        PagedRepository<int>(_FailingSource()),
      );
      await controller.loadFirst();

      expect(controller.state.status, PagedStatus.failure);
      expect(controller.state.message, isNotNull);
      expect(controller.state.items, isEmpty);
    },
  );

  test('refresh invalidates the cache and refetches', () async {
    final source = _ControllerSource({
      null: page([1], null),
    });
    final controller = PagedListController<int>(PagedRepository<int>(source));

    await controller.loadFirst();
    await controller.refresh();

    expect(source.calls, 2);
    expect(controller.state.items, [1]);
  });

  test('updateFilters resets the cursor for the next load', () async {
    final source = _ControllerSource({
      null: page([1], 'p2', hasMore: true),
      'p2': page([2], null),
    });
    final controller = PagedListController<int>(PagedRepository<int>(source));

    await controller.loadFirst();
    controller.updateFilters({'category': 'Flutter'});
    await controller.loadFirst();

    expect(source.lastRequest?.filters, {'category': 'Flutter'});
    expect(source.lastRequest?.cursor, isNull);
  });
}

class _FailingSource implements PagedDataSource<int> {
  @override
  Future<Page<int>> load(PageRequest request) async {
    throw StateError('offline');
  }
}
