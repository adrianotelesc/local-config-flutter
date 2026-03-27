import 'package:flutter_test/flutter_test.dart';
import 'package:local_config/src/common/utils/key_validators.dart';

void main() {
  group('isValidStorageKey', () {
    test('should return true when value contains only lowercase letters', () {
      expect(isValidStorageKey('key'), isTrue);
    });

    test(
      'should return true when value contains lowercase letters and numbers',
      () {
        expect(isValidStorageKey('key123'), isTrue);
      },
    );

    test('should return true when value contains underscores', () {
      expect(isValidStorageKey('my_key'), isTrue);
    });

    test('should return true when value contains only valid characters', () {
      expect(isValidStorageKey('a1_b2_c3'), isTrue);
    });

    test('should return true when value starts with underscore', () {
      expect(isValidStorageKey('_key'), isTrue);
    });

    test('should return true when value ends with underscore', () {
      expect(isValidStorageKey('key_'), isTrue);
    });

    test('should return true when value contains consecutive underscores', () {
      expect(isValidStorageKey('key__name'), isTrue);
    });

    test('should return false when value is empty', () {
      expect(isValidStorageKey(''), isFalse);
    });

    test('should return false when value contains uppercase letters', () {
      expect(isValidStorageKey('Key'), isFalse);
    });

    test('should return false when value contains spaces', () {
      expect(isValidStorageKey('my key'), isFalse);
    });

    test('should return false when value contains special characters', () {
      expect(isValidStorageKey('key-name'), isFalse);
      expect(isValidStorageKey('key.name'), isFalse);
      expect(isValidStorageKey('key@name'), isFalse);
    });

    test('should return false when value contains non-ascii characters', () {
      expect(isValidStorageKey('chave_á'), isFalse);
    });
  });
}
