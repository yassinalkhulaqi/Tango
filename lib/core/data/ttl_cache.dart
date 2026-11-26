import 'dart:async';

class CachePolicy {
  const CachePolicy._();

  static const Duration short = Duration(seconds: 30);
  static const Duration medium = Duration(minutes: 5);
  static const Duration long = Duration(hours: 1);
}

class CacheEntry<T> {
  const CacheEntry({
    required this.value,
    required this.createdAt,
    required this.ttl,
  });

  final T value;
  final DateTime createdAt;
  final Duration ttl;

  bool isExpired(DateTime now) => now.difference(createdAt) >= ttl;
}

class TtlCache<T> {
  TtlCache({this.maxEntries = 64, DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final int maxEntries;
  final DateTime Function() _clock;
  final Map<String, CacheEntry<T>> _entries = <String, CacheEntry<T>>{};
  final Map<String, Future<T>> _inFlight = <String, Future<T>>{};

  int get length => _entries.length;

  bool containsKey(String key) {
    final entry = _entries[key];
    if (entry == null) return false;
    if (entry.isExpired(_clock())) {
      _entries.remove(key);
      return false;
    }
    return true;
  }

  T? get(String key) {
    final entry = _entries[key];
    if (entry == null) return null;
    if (entry.isExpired(_clock())) {
      _entries.remove(key);
      return null;
    }
    return entry.value;
  }

  void set(String key, T value, {Duration ttl = CachePolicy.medium}) {
    if (maxEntries > 0 &&
        _entries.length >= maxEntries &&
        !_entries.containsKey(key)) {
      final oldest = _entries.keys.reduce(
        (a, b) =>
            _entries[a]!.createdAt.isBefore(_entries[b]!.createdAt) ? a : b,
      );
      _entries.remove(oldest);
    }
    _entries[key] = CacheEntry<T>(
      value: value,
      createdAt: _clock(),
      ttl: ttl < Duration.zero ? Duration.zero : ttl,
    );
  }

  void invalidate(String key) {
    _entries.remove(key);
  }

  void invalidateWhere(bool Function(String key) predicate) {
    _entries.removeWhere((key, _) => predicate(key));
  }

  void clear() {
    _entries.clear();
    _inFlight.clear();
  }

  Future<T> getOrLoad({
    required String key,
    required Future<T> Function() loader,
    Duration ttl = CachePolicy.medium,
    bool forceRefresh = false,
  }) {
    if (!forceRefresh) {
      final cached = get(key);
      if (cached != null) return Future<T>.value(cached);
    }
    final pending = _inFlight[key];
    if (pending != null) return pending;

    final future = loader()
        .then((value) {
          set(key, value, ttl: ttl);
          return value;
        })
        .whenComplete(() {
          _inFlight.remove(key);
        });
    _inFlight[key] = future;
    return future;
  }
}
