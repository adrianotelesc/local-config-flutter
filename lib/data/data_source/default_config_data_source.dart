import 'package:local_config/core/storage/key_value_store.dart';
import 'package:local_config/domain/data_source/config_data_source.dart';

class DefaultConfigDataSource extends ConfigDataSource {
  static const _namespace = 'local_config';

  final KeyValueStore _keyValueStore;

  DefaultConfigDataSource({
    required KeyValueStore keyValueStore,
  }) : _keyValueStore = keyValueStore;

  String get _internalKeyPrefix => '$_namespace:';

  @override
  Future<Map<String, String>> get all async {
    final all = await _keyValueStore.all;
    final internalEntries = all.entries
        .where((e) => _isInternalKey(e.key))
        .map((e) => MapEntry(_fromInternalKey(e.key), e.value.toString()));
    return Map<String, String>.fromEntries(internalEntries);
  }

  @override
  Future<String?> get(String key) {
    return _keyValueStore.getString(_toInternalKey(key));
  }

  @override
  Future<void> set(String key, String value) {
    return _keyValueStore.setString(_toInternalKey(key), value);
  }

  @override
  Future<void> remove(String key) {
    return _keyValueStore.remove(_toInternalKey(key));
  }

  @override
  Future<void> clear() async {
    await Future.wait((await all).keys.map(remove));
  }

  @override
  Future<void> prune(Set<String> keysToRetain) async {
    final existingKeys = (await all).keys;
    final keysToRemove = existingKeys.where(
      (key) => !keysToRetain.contains(key),
    );
    await Future.wait(keysToRemove.map(remove));
  }

  bool _isInternalKey(String key) => key.startsWith(_internalKeyPrefix);

  String _toInternalKey(String key) => '$_internalKeyPrefix$key';

  String _fromInternalKey(String key) =>
      key.replaceFirst(_internalKeyPrefix, '');
}
