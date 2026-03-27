import 'package:flutter_test/flutter_test.dart';
import 'package:local_config/src/common/extensions/map_extension.dart';

void main() {
  group('MapExtension.where', () {
    test('should filter entries based on value condition', () {
      final map = {'a': 1, 'b': 2, 'c': 3};

      final result = map.where((key, value) => value.isEven);

      expect(result, {'b': 2});
    });

    test('should return empty map when no entries match condition', () {
      final map = {'a': 1, 'b': 3, 'c': 5};

      final result = map.where((key, value) => value.isEven);

      expect(result, isEmpty);
    });

    test('should return all entries when all match condition', () {
      final map = {'a': 2, 'b': 4};

      final result = map.where((key, value) => value.isEven);

      expect(result, equals(map));
    });

    test('should not mutate original map', () {
      final map = {'a': 1, 'b': 2};

      final result = map.where((key, value) => value > 1);

      expect(map, {'a': 1, 'b': 2});
      expect(result, {'b': 2});
    });

    test('should preserve generic types', () {
      final map = <int, String>{1: 'a', 2: 'bb', 3: 'ccc'};

      final result = map.where((key, value) => value.length > 1);

      expect(result, <int, String>{2: 'bb', 3: 'ccc'});
    });

    test('should preserve insertion order of filtered entries', () {
      final map = {'a': 1, 'b': 2, 'c': 3, 'd': 4};

      final result = map.where((key, value) => value > 1);

      expect(result.keys.toList(), ['b', 'c', 'd']);
    });

    test('should filter entries based on key condition', () {
      final map = {'apple': 1, 'banana': 2, 'avocado': 3};

      final result = map.where((key, value) => key.startsWith('a'));

      expect(result, {
        'apple': 1,
        'avocado': 3,
      });
    });

    test('should return empty map when called on empty map', () {
      final map = <String, int>{};

      final result = map.where((key, value) => true);

      expect(result, isEmpty);
    });
  });
}
