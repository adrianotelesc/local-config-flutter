import 'package:local_config/src/core/persistence/key_value_storage.dart';

class FakeKeyValueStorage implements KeyValueStorage {
  final Map<String, String> _store = {};

  @override
  Future<Map<String, String>> get all async => Map.from(_store);

  @override
  Future<void> setString(String key, String value) async {
    _store[key] = value;
  }

  @override
  Future<void> remove(String key) async {
    _store.remove(key);
  }

  @override
  Future<void> clear() async {
    _store.clear();
  }

  @override
  Future<void> prune(Set<String> keysToKeep) async {
    _store.removeWhere((key, _) => !keysToKeep.contains(key));
  }

  @override
  Future<String?> getString(String key) async => _store[key];
}
