import 'package:flutter_test/flutter_test.dart';
import 'package:local_config/src/core/persistence/key_value_storage.dart';
import 'package:local_config/src/data/repositories/local_config_repository_impl.dart';
import 'package:local_config/src/domain/entities/local_config_update.dart';
import 'package:local_config/src/domain/entities/local_config_value.dart';

import '../../infra/persistence/fake_key_value_storage.dart';

void main() {
  late KeyValueStorage storage;
  late LocalConfigRepositoryImpl repo;

  setUp(() {
    storage = FakeKeyValueStorage();
    repo = LocalConfigRepositoryImpl(storage: storage);
  });

  group('setDefaults', () {
    test('should initialize configs with default values', () async {
      await repo.setDefaults({'a': '1', 'b': '2'});

      expect(repo.defaults.keys, {'a', 'b'});
      expect(repo.getValue('a')?.asString, '1');
      expect(repo.getValue('b')?.asString, '2');
    });

    test('should apply overrides when present in storage', () async {
      await storage.setString('a', '10');

      await repo.setDefaults({'a': '1'});

      expect(repo.getValue('a')?.asString, '10');
      expect(repo.getValue('a')?.source, ValueSource.valueLocal);
    });

    test('should ignore overrides equal to default', () async {
      await storage.setString('a', '1');

      await repo.setDefaults({'a': '1'});

      expect(repo.getValue('a')?.asString, '1');
      expect(repo.getValue('a')?.source, ValueSource.valueDefault);
    });

    test(
      'should retain keys with no matching default across setDefaults',
      () async {
        await storage.setString('free', 'value');

        await repo.setDefaults({'a': '1'});

        expect(repo.getValue('free')?.asString, 'value');
        expect((await storage.all).containsKey('free'), isTrue);
      },
    );
  });

  group('get', () {
    test('should return null when key does not exist', () {
      expect(repo.getValue('unknown'), isNull);
    });
  });

  group('free-form entries (no matching default)', () {
    test('should persist a key that has no default', () async {
      await repo.setDefaults({'a': '1'});

      await repo.set('free', 'value');

      expect(repo.getValue('free')?.asString, 'value');
      expect(repo.getValue('free')?.source, ValueSource.valueLocal);
      expect(await storage.all, containsPair('free', 'value'));
    });

    test('should be included in all', () async {
      await repo.setDefaults({'a': '1'});
      await repo.set('free', 'value');

      expect(repo.all.keys, {'a', 'free'});
      expect(repo.all['free']?.source, ValueSource.valueLocal);
    });

    test('should be fully removed on reset', () async {
      await repo.setDefaults({'a': '1'});
      await repo.set('free', 'value');

      await repo.reset('free');

      expect(repo.getValue('free'), isNull);
      expect((await storage.all).containsKey('free'), isFalse);
    });

    test(
      'should be included in resetAll',
      () async {
        await repo.setDefaults({'a': '1'});
        await repo.set('free', 'value');

        await repo.resetAll();

        expect(repo.getValue('free'), isNull);
        expect(await storage.all, isEmpty);
      },
    );

    test(
      'should become a regular override once a default is added for it',
      () async {
        await repo.setDefaults({});
        await repo.set('free', 'value');

        await repo.setDefaults({'free': 'default'});

        expect(repo.getValue('free')?.asString, 'value');
        expect(repo.getValue('free')?.source, ValueSource.valueLocal);
        expect(repo.defaults.containsKey('free'), isTrue);
      },
    );

    test(
      'should discard a free entry if its value matches the newly-added default',
      () async {
        await storage.setString('free', 'same');

        await repo.setDefaults({'free': 'same'});

        expect(repo.getValue('free')?.asString, 'same');
        expect(repo.getValue('free')?.source, ValueSource.valueDefault);
        expect((await storage.all).containsKey('free'), isFalse);
      },
    );
  });

  group('set', () {
    test(
      'should update override and persist when value differs from default',
      () async {
        await repo.setDefaults({'a': '1'});

        await repo.set('a', '2');

        expect(repo.getValue('a')?.asString, '2');
        expect(await storage.all, {'a': '2'});
      },
    );

    test('should remove override when value equals default', () async {
      await repo.setDefaults({'a': '1'});

      await repo.set('a', '2');
      await repo.set('a', '1');

      expect(repo.getValue('a')?.source, ValueSource.valueDefault);
      expect((await storage.all).containsKey('a'), isFalse);
    });

    test('should emit update event when value changes', () async {
      await repo.setDefaults({'a': '1'});

      expectLater(
        repo.onConfigUpdated,
        emits(
          predicate<LocalConfigUpdate>(
            (e) => e.updatedKeys.contains('a'),
          ),
        ),
      );

      await repo.set('a', '2');
    });
  });

  group('reset', () {
    test('should remove override and restore default value', () async {
      await repo.setDefaults({'a': '1'});
      await repo.set('a', '2');

      await repo.reset('a');

      expect(repo.getValue('a')?.asString, '1');
      expect((await storage.all).containsKey('a'), isFalse);
    });

    test('should emit update event on reset', () async {
      await repo.setDefaults({'a': '1', 'b': '2'});
      await repo.set('a', '2');
      await repo.set('b', '3');

      expectLater(
        repo.onConfigUpdated,
        emits(
          predicate<LocalConfigUpdate>(
            (e) => e.updatedKeys.contains('a'),
          ),
        ),
      );

      await repo.reset('a');
    });
  });

  group('resetAll', () {
    test('should clear all overrides and restore defaults', () async {
      await repo.setDefaults({'a': '1', 'b': '2'});
      await repo.set('a', '10');
      await repo.set('b', '20');

      await repo.resetAll();

      expect(repo.getValue('a')?.asString, '1');
      expect(repo.getValue('b')?.asString, '2');
      expect(await storage.all, isEmpty);
    });

    test('should emit update event with all keys', () async {
      await repo.setDefaults({'a': '1', 'b': '2'});

      await repo.set('a', '10');
      await repo.set('b', '20');

      expectLater(
        repo.onConfigUpdated,
        emits(
          predicate<LocalConfigUpdate>(
            (e) => e.updatedKeys.containsAll({'a', 'b'}),
          ),
        ),
      );

      await repo.resetAll();
    });
  });
}
