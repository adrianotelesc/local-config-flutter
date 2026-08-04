import 'package:flutter_test/flutter_test.dart';
import 'package:local_config/src/domain/repositories/local_config_repository.dart';
import 'package:local_config/src/presentation/notifiers/config_editing_notifier.dart';

import '../../data/repositories/fake_local_config_repository_impl.dart';

void main() {
  late LocalConfigRepository repo;
  late ConfigEditingNotifier notifier;

  setUp(() async {
    repo = FakeLocalConfigRepositoryImpl();
    await repo.setDefaults({'a': '1'});

    notifier = ConfigEditingNotifier(configRepo: repo);
  });

  group('a parameter with a default', () {
    test('should load the default value when no override exists', () {
      notifier.load('a');

      expect(notifier.configValue.isCustom, isFalse);
      expect(notifier.configValue.defaultValue, '1');
      expect(notifier.showEditingLocalValue, isFalse);
    });

    test('should save an override', () async {
      notifier.load('a');

      notifier.save('a', '2');

      expect(repo.getValue('a')?.asString, '2');
    });

    test(
      'should ignore a different name (defaults cannot be renamed)',
      () async {
        notifier.load('a');

        notifier.save('renamed', '2');

        expect(repo.getValue('a')?.asString, '2');
        expect(repo.getValue('renamed'), isNull);
      },
    );
  });

  group('a free-form entry (no default)', () {
    setUp(() async {
      await repo.set('free', 'value');
    });

    test('should load the entry as custom', () {
      notifier.load('free');

      expect(notifier.configValue.isCustom, isTrue);
      expect(notifier.configValue.defaultValue, 'value');
      expect(notifier.showEditingLocalValue, isTrue);
      expect(notifier.initialEditingLocalValue, 'value');
    });

    test('should save an updated value', () async {
      notifier.load('free');

      notifier.save('free', 'updated');

      expect(repo.getValue('free')?.asString, 'updated');
    });

    test(
      'should be fully deleted when saved with shouldResetToDefault',
      () async {
        notifier.load('free');

        notifier.shouldResetToDefault = true;
        notifier.save('free', 'value');

        expect(repo.getValue('free'), isNull);
      },
    );

    test('should be renamed when saved under a different name', () async {
      notifier.load('free');

      notifier.save('renamed', 'value');

      expect(repo.getValue('free'), isNull);
      expect(repo.getValue('renamed')?.asString, 'value');
    });
  });

  group('adding a new entry', () {
    test('nameExists should return false for an unused name', () {
      expect(notifier.nameExists('new'), isFalse);
    });

    test('nameExists should return true for a default parameter', () {
      expect(notifier.nameExists('a'), isTrue);
    });

    test('nameExists should return true for an existing free entry', () async {
      await repo.set('free', 'value');

      expect(notifier.nameExists('free'), isTrue);
    });

    test('add should persist a new free-form entry', () async {
      await notifier.add('new', 'value');

      expect(repo.getValue('new')?.asString, 'value');
    });
  });
}
