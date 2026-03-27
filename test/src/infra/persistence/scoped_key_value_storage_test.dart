import 'package:flutter_test/flutter_test.dart';
import 'package:local_config/src/infra/models/key_namespace.dart';
import 'package:local_config/src/infra/persistence/scoped_key_value_storage.dart';

import 'fake_key_value_storage.dart';

void main() {
  late FakeKeyValueStorage delegate;
  late ScopedKeyValueStorage storage;
  late KeyNamespace namespace;

  setUp(() {
    delegate = FakeKeyValueStorage();
    namespace = KeyNamespace(base: 'app', segments: ['user']);
    storage = ScopedKeyValueStorage(
      namespace: namespace,
      delegate: delegate,
    );
  });

  group('all', () {
    test('should return only qualified keys within namespace', () async {
      await delegate.setString('app_user_key', '1');
      await delegate.setString('app_other_key', '2');
      await delegate.setString('other_key', '3');

      final result = await storage.all;

      expect(result, {'key': '1'});
    });

    test('should strip namespace prefix from returned keys', () async {
      await delegate.setString('app_user_my_key', '1');

      final result = await storage.all;

      expect(result, {'my_key': '1'});
    });
  });

  group('getString', () {
    test('should return value using qualified key', () async {
      await delegate.setString('app_user_key', 'value');

      final result = await storage.getString('key');

      expect(result, 'value');
    });
  });

  group('setString', () {
    test('should store value using qualified key', () async {
      await storage.setString('key', 'value');

      expect(await delegate.all, {'app_user_key': 'value'});
    });

    test('should throw when key is invalid', () async {
      expect(
        () => storage.setString('invalid-key', 'value'),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('remove', () {
    test('should remove value using qualified key', () async {
      await delegate.setString('app_user_key', 'value');

      await storage.remove('key');

      expect(await delegate.all, isEmpty);
    });
  });

  group('prune', () {
    test('should remove non-qualified keys within base namespace', () async {
      await delegate.setString('app_key', '1'); // base-only
      await delegate.setString('app_user_key', '2'); // qualified

      await storage.prune({'key'});

      expect(await delegate.all, {'app_user_key': '2'});
    });

    test('should remove qualified keys not in retained set', () async {
      await delegate.setString('app_user_a', '1');
      await delegate.setString('app_user_b', '2');

      await storage.prune({'a'});

      expect(await delegate.all, {'app_user_a': '1'});
    });

    test('should ignore keys outside base namespace', () async {
      await delegate.setString('other_key', '1');

      await storage.prune({});

      expect(await delegate.all, {'other_key': '1'});
    });
  });

  group('clear', () {
    test('should remove all keys within base namespace', () async {
      await delegate.setString('app_user_a', '1');
      await delegate.setString('app_other_b', '2');
      await delegate.setString('other_key', '3');

      await storage.clear();

      expect(await delegate.all, {'other_key': '3'});
    });
  });
}
