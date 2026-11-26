/// A generic in-memory repository with CRUD + query helpers.
///
/// Presentation-layer data source used by dashboards and lists. It performs no
/// network I/O; it holds view models already fetched by the secured layer.
class MemoryRepository<T> {
  final String Function(T) _idOf;
  final Map<String, T> _items = {};

  MemoryRepository(this._idOf);

  void put(T item) => _items[_idOf(item)] = item;
  void putAll(Iterable<T> items) => items.forEach(put);

  T? get(String id) => _items[id];
  List<T> all() => _items.values.toList(growable: false);

  bool remove(String id) => _items.remove(id) != null;
  void clear() => _items.clear();

  List<T> where(bool Function(T) test) => _items.values.where(test).toList();

  List<T> page(int offset, int limit) {
    final values = _items.values.toList();
    if (offset >= values.length) return [];
    final end = (offset + limit).clamp(0, values.length);
    return values.sublist(offset, end);
  }

  int count() => _items.length;
  bool exists(String id) => _items.containsKey(id);
}

/// A simple TTL cache for view models keyed by string.
class ViewModelCache<T> {
  final Map<String, _Entry<T>> _cache = {};
  final Duration ttl;

  ViewModelCache({this.ttl = const Duration(minutes: 5)});

  T? get(String key) {
    final entry = _cache[key];
    if (entry == null) return null;
    if (DateTime.now().difference(entry.at) > ttl) {
      _cache.remove(key);
      return null;
    }
    return entry.value;
  }

  void set(String key, T value) => _cache[key] = _Entry(value, DateTime.now());

  void invalidate(String key) => _cache.remove(key);
  void clear() => _cache.clear();
  int get size => _cache.length;
}

class _Entry<T> {
  final T value;
  final DateTime at;
  _Entry(this.value, this.at);
}
