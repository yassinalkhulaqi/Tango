import 'package:flutter_test/flutter_test.dart';
import 'package:tango/features/services_v2/domain/memory_repository.dart';

class Item {
  final String id;
  final String name;
  Item(this.id, this.name);
}

void main() {
  group('MemoryRepository', () {
    test('put and get', () {
      final repo = MemoryRepository<Item>((i) => i.id);
      repo.put(Item('1', 'One'));
      expect(repo.get('1')!.name, 'One');
    });

    test('where filters', () {
      final repo = MemoryRepository<Item>((i) => i.id);
      repo.putAll([Item('1', 'One'), Item('2', 'Two')]);
      expect(repo.where((i) => i.id == '2').length, 1);
    });

    test('pagination', () {
      final repo = MemoryRepository<Item>((i) => i.id);
      repo.putAll(List.generate(10, (i) => Item('$i', 'n$i')));
      expect(repo.page(0, 3).length, 3);
      expect(repo.page(9, 3).length, 1);
      expect(repo.page(12, 3), isEmpty);
    });

    test('remove and clear', () {
      final repo = MemoryRepository<Item>((i) => i.id);
      repo.put(Item('1', 'One'));
      expect(repo.remove('1'), isTrue);
      expect(repo.count(), 0);
    });
  });

  group('ViewModelCache', () {
    test('stores and retrieves', () {
      final cache = ViewModelCache<String>();
      cache.set('k', 'v');
      expect(cache.get('k'), 'v');
    });

    test('expires after ttl', () async {
      final cache = ViewModelCache<String>(ttl: Duration.zero);
      cache.set('k', 'v');
      await Future<void>.delayed(const Duration(milliseconds: 5));
      expect(cache.get('k'), isNull);
    });

    test('invalidate', () {
      final cache = ViewModelCache<String>();
      cache.set('k', 'v');
      cache.invalidate('k');
      expect(cache.get('k'), isNull);
    });
  });
}
