import 'package:flutter_test/flutter_test.dart';
import 'package:local_config/src/common/extensions/string_extension.dart';

void main() {
  group('StringExtension.containsInsensitive', () {
    test('should return true when substring matches ignoring case', () {
      const value = 'Hello World';

      final result = value.containsInsensitive('hello');

      expect(result, isTrue);
    });

    test('should return true when substring matches with different casing', () {
      const value = 'Flutter';

      final result = value.containsInsensitive('FLUT');

      expect(result, isTrue);
    });

    test('should return false when substring does not exist', () {
      const value = 'Dart';

      final result = value.containsInsensitive('java');

      expect(result, isFalse);
    });

    test('should return true when search string is empty', () {
      const value = 'Anything';

      final result = value.containsInsensitive('');

      expect(result, isTrue);
    });

    test(
      'should return false when original string is empty and search is not',
      () {
        const value = '';

        final result = value.containsInsensitive('a');

        expect(result, isFalse);
      },
    );

    test('should return true when both strings are empty', () {
      const value = '';

      final result = value.containsInsensitive('');

      expect(result, isTrue);
    });

    test('should handle special characters correctly', () {
      const value = 'Olá Mundo';

      final result = value.containsInsensitive('olá');

      expect(result, isTrue);
    });

    test(
      'should behave like contains when both strings are already lowercase',
      () {
        const value = 'hello world';

        final result = value.containsInsensitive('world');

        expect(result, value.contains('world'));
      },
    );
  });
}
