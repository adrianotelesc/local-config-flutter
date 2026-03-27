import 'package:flutter_test/flutter_test.dart';
import 'package:local_config/local_config.dart';
import 'package:local_config/src/domain/entities/local_config_update.dart';
import 'package:local_config/src/local_config_internals.dart';

import 'infra/persistence/fake_key_value_storage.dart';

void main() {
  late LocalConfig config;
  late FakeKeyValueStorage storage;

  setUp(() async {
    config = LocalConfig.instance;
    config.reset();

    storage = FakeKeyValueStorage();

    await config.initialize(
      configSettings: LocalConfigSettings(
        keyValueStorage: storage,
        keyNamespaceSegments: ['test'],
      ),
    );
  });

  group('initialize', () {
    test('should set initialized to true after initialization', () {
      expect(config.initialized, isTrue);
    });
  });

  group('setDefaults', () {
    test('should store default values as strings', () async {
      await config.setDefaults({
        'a': '1',
        'b': true,
        'c': 10,
      });

      final all = config.all;

      expect(all['a']?.asString, '1');
      expect(all['b']?.asString, 'true');
      expect(all['c']?.asString, '10');
    });
  });

  group('getters', () {
    setUp(() async {
      await config.setDefaults({
        'a': '1',
        'b': true,
        'c': 10,
        'd': 10.5,
      });
    });

    test('should return string value', () {
      expect(config.getString('a'), '1');
    });

    test('should return bool value', () {
      expect(config.getBool('b'), isTrue);
    });

    test('should return int value', () {
      expect(config.getInt('c'), 10);
    });

    test('should return double value', () {
      expect(config.getDouble('d'), 10.5);
    });

    test('should return null when key does not exist', () {
      expect(config.getValue('unknown'), isNull);
    });
  });

  group('all', () {
    test('should return all configs', () async {
      await config.setDefaults({'a': '1', 'b': '2'});

      final all = config.all;

      expect(all.keys, containsAll({'a', 'b'}));
    });

    test('should return a copy of configs map', () async {
      await config.setDefaults({'a': '1'});

      final all = config.all;

      all.remove('a');

      // original não deve ser afetado
      expect(config.all.containsKey('a'), isTrue);
    });
  });

  group('resetAll', () {
    test('should reset all values to default', () async {
      await config.setDefaults({'a': '1'});

      await configRepo.set('a', '10');

      await config.resetAll();

      expect(config.getString('a'), '1');
    });
  });

  group('onConfigUpdated', () {
    test('should emit updates when config changes', () async {
      await config.setDefaults({'a': '1'});

      final future = expectLater(
        config.onConfigUpdated,
        emits(
          predicate<LocalConfigUpdate>(
            (e) => e.updatedKeys.contains('a'),
          ),
        ),
      );

      await configRepo.set('a', '10');

      await future;
    });
  });

  group('reset (testing only)', () {
    test('should reset initialized state and repository', () async {
      expect(config.initialized, isTrue);

      config.reset();

      expect(config.initialized, isFalse);
      expect(config.all, isEmpty);
    });
  });

  group('usage before initialization', () {
    test('should return null when accessing values before initialization', () {
      config.reset();

      expect(config.getValue('a'), isNull);
      expect(config.getString('a'), isNull);
      expect(config.getBool('a'), isNull);
    });

    test(
      'should not throw when calling resetAll before initialization',
      () async {
        config.reset();

        expect(() => config.resetAll(), returnsNormally);
      },
    );

    test('should expose empty configs when not initialized', () {
      config.reset();

      expect(config.all, isEmpty);
    });
  });
}
