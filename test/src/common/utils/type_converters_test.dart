import 'package:flutter_test/flutter_test.dart';
import 'package:local_config/src/common/utils/type_converters.dart';

void main() {
  group('stringify', () {
    test('should return same string when object is already a string', () {
      const value = 'hello';

      final result = stringify(value);

      expect(result, 'hello');
    });

    test('should return json string when object is a map', () {
      final result = stringify({'a': 1});

      expect(result, '{"a":1}');
    });

    test('should return json string when object is a list', () {
      final result = stringify([1, 2, 3]);

      expect(result, '[1,2,3]');
    });

    test('should fallback to toString when json encoding fails', () {
      final value = {'a': Object()};

      final result = stringify(value);

      expect(result, value.toString());
    });

    test('should return toString for non-collection objects', () {
      final result = stringify(123);

      expect(result, '123');
    });
  });

  group('tryParseBool', () {
    test('should return same value when object is bool', () {
      expect(tryParseBool(true), isTrue);
      expect(tryParseBool(false), isFalse);
    });

    test('should return true when object is number 1', () {
      expect(tryParseBool(1), isTrue);
    });

    test('should return false when object is number 0', () {
      expect(tryParseBool(0), isFalse);
    });

    test('should return null when number is not 0 or 1', () {
      expect(tryParseBool(2), isNull);
      expect(tryParseBool(-1), isNull);
    });

    test('should parse string "true" and "false" ignoring case', () {
      expect(tryParseBool('true'), isTrue);
      expect(tryParseBool('FALSE'), isFalse);
    });

    test('should parse string "1" and "0"', () {
      expect(tryParseBool('1'), isTrue);
      expect(tryParseBool('0'), isFalse);
    });

    test('should trim string before parsing', () {
      expect(tryParseBool('  true  '), isTrue);
    });

    test('should return null for invalid string', () {
      expect(tryParseBool('yes'), isNull);
      expect(tryParseBool('no'), isNull);
    });

    test('should return null for unsupported types', () {
      expect(tryParseBool({}), isNull);
      expect(tryParseBool([]), isNull);
    });
  });

  group('tryJsonDecode', () {
    test('should return decoded map when json is valid object', () {
      final result = tryJsonDecode('{"a":1}');

      expect(result, {'a': 1});
    });

    test('should return decoded list when json is valid array', () {
      final result = tryJsonDecode('[1,2,3]');

      expect(result, [1, 2, 3]);
    });

    test('should return null when json is invalid', () {
      final result = tryJsonDecode('{invalid json}');

      expect(result, isNull);
    });
  });

  group('tryJsonEncode', () {
    test('should return json string when object is encodable', () {
      final result = tryJsonEncode({'a': 1});

      expect(result, '{"a":1}');
    });

    test('should return null when object is not encodable', () {
      final result = tryJsonEncode({'a': Object()});

      expect(result, isNull);
    });
  });
}
