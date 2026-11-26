import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/api_client.dart';
import 'ttl_cache.dart';

class PageRequest {
  const PageRequest({
    this.cursor,
    this.limit = 20,
    this.filters = const <String, dynamic>{},
  });

  final String? cursor;
  final int limit;
  final Map<String, dynamic> filters;

  PageRequest copyWith({
    String? cursor,
    int? limit,
    Map<String, dynamic>? filters,
    bool clearCursor = false,
  }) {
    return PageRequest(
      cursor: clearCursor ? null : (cursor ?? this.cursor),
      limit: limit ?? this.limit,
      filters: filters ?? this.filters,
    );
  }

  Map<String, dynamic> toQueryParameters() {
    return <String, dynamic>{
      ...filters,
      'limit': limit,
      if (cursor != null && cursor!.isNotEmpty) 'cursor': cursor,
    };
  }

  @override
  String toString() =>
      'PageRequest(cursor: $cursor, limit: $limit, filters: $filters)';
}

class Page<T> {
  const Page({
    required this.items,
    required this.hasMore,
    this.nextCursor,
    this.total,
  });

  final List<T> items;
  final bool hasMore;
  final String? nextCursor;
  final int? total;

  bool get isEmpty => items.isEmpty;

  factory Page.fromEnvelope(
    ListEnvelope<T> envelope, {
    String? Function(ApiMeta meta)? cursorOf,
  }) {
    final cursor =
        cursorOf?.call(envelope.meta) ??
        envelope.meta.extra['nextCursor'] as String? ??
        envelope.meta.extra['cursor'] as String?;
    final hasMore =
        envelope.meta.hasMore ?? (cursor != null && cursor.isNotEmpty);
    return Page<T>(
      items: envelope.items,
      hasMore: hasMore,
      nextCursor: cursor,
      total: envelope.meta.total,
    );
  }

  Page<T> copyWithItems(List<T> nextItems) => Page<T>(
    items: nextItems,
    hasMore: hasMore,
    nextCursor: nextCursor,
    total: total,
  );
}

abstract class PagedDataSource<T> {
  Future<Page<T>> load(PageRequest request);
}

class PagedRepository<T> {
  PagedRepository(
    this._source, {
    TtlCache<Page<T>>? cache,
    this.defaultTtl = CachePolicy.short,
  }) : _cache = cache ?? TtlCache<Page<T>>();

  final PagedDataSource<T> _source;
  final TtlCache<Page<T>> _cache;
  final Duration defaultTtl;

  String keyFor(PageRequest request) {
    final filters = request.filters.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return '${filters.map((e) => '${e.key}=${e.value}').join(',')}|${request.cursor ?? 'first'}|${request.limit}';
  }

  Future<Page<T>> loadPage(PageRequest request, {bool forceRefresh = false}) {
    return _cache.getOrLoad(
      key: keyFor(request),
      ttl: defaultTtl,
      forceRefresh: forceRefresh,
      loader: () => _source.load(request),
    );
  }

  Future<List<T>> loadAll({
    PageRequest request = const PageRequest(),
    int maxPages = 10,
  }) async {
    final items = <T>[];
    var cursor = request.cursor;
    for (var pageIndex = 0; pageIndex < maxPages; pageIndex++) {
      final page = await loadPage(
        request.copyWith(cursor: cursor, clearCursor: cursor == null),
      );
      items.addAll(page.items);
      if (!page.hasMore || page.nextCursor == null || page.items.isEmpty) break;
      cursor = page.nextCursor;
    }
    return items;
  }

  void invalidate({bool Function(String key)? where}) {
    if (where == null) {
      _cache.clear();
      return;
    }
    _cache.invalidateWhere(where);
  }
}

enum PagedStatus { initial, loading, loadingMore, ready, failure }

class PagedListState<T> {
  PagedListState({
    this.status = PagedStatus.initial,
    List<T>? items,
    this.nextCursor,
    this.hasMore = true,
    this.message,
  }) : items = items ?? <T>[];

  final PagedStatus status;
  final List<T> items;
  final String? nextCursor;
  final bool hasMore;
  final String? message;

  bool get isBusy =>
      status == PagedStatus.loading || status == PagedStatus.loadingMore;

  PagedListState<T> copyWith({
    PagedStatus? status,
    List<T>? items,
    String? nextCursor,
    bool? hasMore,
    String? message,
    bool clearMessage = false,
    bool clearCursor = false,
  }) {
    return PagedListState<T>(
      status: status ?? this.status,
      items: items ?? this.items,
      nextCursor: clearCursor ? null : (nextCursor ?? this.nextCursor),
      hasMore: hasMore ?? this.hasMore,
      message: clearMessage ? null : (message ?? this.message),
    );
  }
}

class PagedListController<T> extends StateNotifier<PagedListState<T>> {
  PagedListController(
    this._repository, {
    PageRequest this._baseRequest = const PageRequest(),
  }) : super(PagedListState<T>());

  final PagedRepository<T> _repository;
  PageRequest _baseRequest;

  Future<void> loadFirst({bool forceRefresh = false}) async {
    if (state.status == PagedStatus.loading) return;
    state = state.copyWith(
      status: PagedStatus.loading,
      clearMessage: true,
      clearCursor: true,
    );
    await _load(
      forceRefresh: forceRefresh,
      append: false,
      request: _baseRequest,
    );
  }

  Future<void> loadMore() async {
    if (state.isBusy || !state.hasMore || state.nextCursor == null) return;
    state = state.copyWith(status: PagedStatus.loadingMore, clearMessage: true);
    await _load(
      append: true,
      request: _baseRequest.copyWith(cursor: state.nextCursor),
    );
  }

  Future<void> refresh() async {
    _repository.invalidate();
    await loadFirst(forceRefresh: true);
  }

  void updateFilters(Map<String, dynamic> filters) {
    _baseRequest = _baseRequest.copyWith(filters: filters, clearCursor: true);
  }

  Future<void> _load({
    required bool append,
    required PageRequest request,
    bool forceRefresh = false,
  }) async {
    try {
      final page = await _repository.loadPage(
        request,
        forceRefresh: forceRefresh,
      );
      final items = append ? <T>[...state.items, ...page.items] : page.items;
      state = state.copyWith(
        status: PagedStatus.ready,
        items: items,
        nextCursor: page.nextCursor,
        hasMore: page.hasMore,
        clearMessage: true,
        clearCursor: page.nextCursor == null,
      );
    } catch (error) {
      state = state.copyWith(
        status: PagedStatus.failure,
        message: 'Could not load data. Check your connection and try again.',
        clearMessage: false,
      );
    }
  }
}
