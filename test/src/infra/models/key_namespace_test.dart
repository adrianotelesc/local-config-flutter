import 'package:flutter_test/flutter_test.dart';
import 'package:local_config/src/infra/models/key_namespace.dart';

void main() {
  group('KeyNamespace.constructor', () {
    test('should create instance with valid base and segments', () {
      final ns = KeyNamespace(base: 'app', segments: ['user']);

      expect(ns.hasBasePrefix('app_key'), isTrue);
    });

    test('should throw assertion error when base is empty', () {
      expect(
        () => KeyNamespace(base: ''),
        throwsA(isA<AssertionError>()),
      );
    });

    test('should throw assertion error when segments contain empty string', () {
      expect(
        () => KeyNamespace(base: 'app', segments: ['']),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('hasBasePrefix', () {
    test('should return true when key starts with base prefix', () {
      final ns = KeyNamespace(base: 'app');

      expect(ns.hasBasePrefix('app_key'), isTrue);
    });

    test('should return false when key does not start with base prefix', () {
      final ns = KeyNamespace(base: 'app');

      expect(ns.hasBasePrefix('other_key'), isFalse);
    });
  });

  group('hasQualifiedPrefix', () {
    test('should return true when key starts with qualified prefix', () {
      final ns = KeyNamespace(base: 'app', segments: ['user']);

      expect(ns.hasQualifiedPrefix('app_user_key'), isTrue);
    });

    test('should return false when key does not match qualified prefix', () {
      final ns = KeyNamespace(base: 'app', segments: ['user']);

      expect(ns.hasQualifiedPrefix('app_key'), isFalse);
    });
  });

  group('qualify', () {
    test('should prepend qualified prefix when key has no prefix', () {
      final ns = KeyNamespace(base: 'app', segments: ['user']);

      final result = ns.qualify('key');

      expect(result, 'app_user_key');
    });

    test('should upgrade base-prefixed key to qualified prefix', () {
      final ns = KeyNamespace(base: 'app', segments: ['user']);

      final result = ns.qualify('app_key');

      expect(result, 'app_user_key');
    });

    test('should return key unchanged when already qualified', () {
      final ns = KeyNamespace(base: 'app', segments: ['user']);

      final result = ns.qualify('app_user_key');

      expect(result, 'app_user_key');
    });

    test('should throw when key is empty', () {
      final ns = KeyNamespace(base: 'app');

      expect(
        () => ns.qualify(''),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should throw when key equals base prefix', () {
      final ns = KeyNamespace(base: 'app');

      expect(
        () => ns.qualify('app_'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should throw when key equals qualified prefix', () {
      final ns = KeyNamespace(base: 'app', segments: ['user']);

      expect(
        () => ns.qualify('app_user_'),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('strip', () {
    test('should remove qualified prefix when present', () {
      final ns = KeyNamespace(base: 'app', segments: ['user']);

      final result = ns.strip('app_user_key');

      expect(result, 'key');
    });

    test('should remove base prefix when qualified prefix is not present', () {
      final ns = KeyNamespace(base: 'app');

      final result = ns.strip('app_key');

      expect(result, 'key');
    });

    test('should return key unchanged when no prefix is present', () {
      final ns = KeyNamespace(base: 'app');

      final result = ns.strip('key');

      expect(result, 'key');
    });
  });

  group('equality', () {
    test('should return true when base and segments are equal', () {
      final a = KeyNamespace(base: 'app', segments: ['user']);
      final b = KeyNamespace(base: 'app', segments: ['user']);

      expect(a, equals(b));
    });

    test('should return false when base differs', () {
      final a = KeyNamespace(base: 'app');
      final b = KeyNamespace(base: 'other');

      expect(a == b, isFalse);
    });

    test('should return false when segments differ', () {
      final a = KeyNamespace(base: 'app', segments: ['user']);
      final b = KeyNamespace(base: 'app', segments: ['admin']);

      expect(a == b, isFalse);
    });
  });
}
