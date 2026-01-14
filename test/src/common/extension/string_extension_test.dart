import 'package:flutter_test/flutter_test.dart';
import 'package:local_config/src/common/extension/string_extension.dart';

void main() {
  group('StringExtension.toMapOrNull()', () {
    test('returns Map when string is valid JSON', () {
      const string = '{"a":1,"b":2}';

      final result = string.toMapOrNull();

      expect(result, isA<Map<String, dynamic>>());
      expect(result?['a'], 1);
      expect(result?['b'], 2);
    });

    test('returns null when string is not valid JSON', () {
      const string = 'not a json';

      final result = string.toMapOrNull();

      expect(result, isNull);
    });

    test('returns Map when string is empty JSON', () {
      const string = '{}';

      final result = string.toMapOrNull();

      expect(result, isA<Map<String, dynamic>>());
      expect(result, isEmpty);
    });
  });

  group('StringExtension.toBoolOrNull()', () {
    test('returns true when string is "true"', () {
      const string = 'true';

      final result = string.toBoolOrNull();

      expect(result, isTrue);
    });

    test('returns false when string is "false"', () {
      const string = 'false';

      final result = string.toBoolOrNull();

      expect(result, isFalse);
    });

    test('returns null when string is invalid boolean', () {
      const string = 'not a boolean';

      final result = string.toBoolOrNull();

      expect(result, isNull);
    });
  });

  group('StringExtension.toDoubleOrNull()', () {
    test('returns double when string is valid double', () {
      const string = '3.14';

      final result = string.toDoubleOrNull();

      expect(result, 3.14);
    });

    test('returns double when string is valid integer', () {
      const string = '42';

      final result = string.toDoubleOrNull();

      expect(result, 42.0);
    });

    test('returns null when string is invalid double', () {
      expect('abc'.toDoubleOrNull(), isNull);
    });
  });

  group('StringExtension.toIntOrNull()', () {
    test('returns integer when string is valid integer', () {
      const string = '123';

      final result = string.toIntOrNull();

      expect(result, 123);
    });

    test('returns null when string is valid double', () {
      const string = '3.14';

      final result = string.toIntOrNull();

      expect(result, isNull);
    });

    test('returns null when string is invalid integer', () {
      const string = 'not a integer';

      final result = string.toIntOrNull();

      expect(result, isNull);
    });
  });

  group('StringExtension.containsInsensitive', () {
    const string = 'Hello World';

    test('returns true when substring exists ignoring lowercase', () {
      const substring = 'hello';

      final result = string.containsInsensitive(substring);

      expect(result, isTrue);
    });

    test('returns true when substring exists ignoring uppercase', () {
      const substring = 'WORLD';

      final result = string.containsInsensitive(substring);

      expect(result, isTrue);
    });

    test('returns false when substring does not exist', () {
      const substring = 'dart';

      final result = string.containsInsensitive(substring);

      expect(result, isFalse);
    });

    test('matches empty substring', () {
      const substring = '';

      final result = string.containsInsensitive(substring);

      expect(result, isTrue);
    });
  });
}
