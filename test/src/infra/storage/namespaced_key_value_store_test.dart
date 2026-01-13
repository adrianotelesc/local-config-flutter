import 'package:flutter_test/flutter_test.dart';
import 'package:local_config/src/common/util/key_namespace.dart';
import 'package:local_config/src/core/storage/key_value_store.dart';
import 'package:local_config/src/infra/storage/namespaced_key_value_store.dart';
import 'package:mocktail/mocktail.dart';

class MockKeyNamespace extends Mock implements KeyNamespace {}

class MockKeyValueStore extends Mock implements KeyValueStore {}

void main() {
  late MockKeyNamespace namespace;
  late MockKeyValueStore inner;
  late NamespacedKeyValueStore store;

  setUp(() {
    inner = MockKeyValueStore();
    namespace = MockKeyNamespace();

    store = NamespacedKeyValueStore(namespace: namespace, inner: inner);
  });

  group('NamespacedKeyValueStore.all', () {
    test('returns only namespaced keys with prefix removed', () async {
      const all = {'ns:foo': 'bar', 'other:key': 'value'};

      when(() => inner.all).thenAnswer((_) async => all);
      when(() => namespace.matches('ns:foo')).thenReturn(true);
      when(() => namespace.matches('other:key')).thenReturn(false);
      when(() => namespace.strip('ns:foo')).thenReturn('foo');

      final result = await store.all;

      expect(result.length, 1);
      expect(result['foo'], 'bar');
      expect(result.containsKey('other:key'), isFalse);
    });

    test('returns empty map when no namespaced keys', () async {
      const all = {'other:key': 'value'};

      when(() => inner.all).thenAnswer((_) async => all);
      when(() => namespace.matches('other:key')).thenReturn(false);

      final result = await store.all;

      expect(result, isEmpty);
    });
  });

  group('NamespacedKeyValueStore.getString', () {
    test('applies namespace and delegates to inner store', () async {
      const key = 'foo';
      const namespacedKey = 'ns:foo';
      const value = 'bar';

      when(() => namespace.apply(key)).thenReturn(namespacedKey);
      when(() => inner.getString(namespacedKey)).thenAnswer((_) async => value);

      final result = await store.getString(key);

      expect(result, value);
      verify(() => namespace.apply(key)).called(1);
      verify(() => inner.getString(namespacedKey)).called(1);
    });
  });

  group('NamespacedKeyValueStore.setString', () {
    test('applies namespace and delegates to inner store', () async {
      const key = 'foo';
      const value = 'bar';
      const namespacedKey = 'ns:foo';

      when(() => namespace.apply(key)).thenReturn(namespacedKey);
      when(
        () => inner.setString(namespacedKey, value),
      ).thenAnswer((_) async {});

      await store.setString(key, value);

      verify(() => namespace.apply(key)).called(1);
      verify(() => inner.setString(namespacedKey, value)).called(1);
    });
  });

  group('NamespacedKeyValueStore.remove', () {
    test('applies namespace and delegates to inner store', () async {
      const key = 'foo';
      const namespacedKey = 'ns:foo';

      when(() => namespace.apply(key)).thenReturn(namespacedKey);
      when(() => inner.remove(namespacedKey)).thenAnswer((_) async {});

      await store.remove(key);

      verify(() => namespace.apply(key)).called(1);
      verify(() => inner.remove(namespacedKey)).called(1);
    });
  });
}
