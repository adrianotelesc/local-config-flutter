import 'package:local_config/storage/key_value_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesStore extends KeyValueStore {
  static const _namespace = 'local_config:';

  final _sharedPreferences = SharedPreferencesAsync();

  @override
  Future<Map<String, dynamic>> get data async {
    final preferences = await _sharedPreferences.getAll();
    final entries = preferences.entries
        .where((entry) => _isInternalKey(entry.key))
        .map((entry) => MapEntry(_fromInternalKey(entry.key), entry.value));
    return Map<String, dynamic>.fromEntries(entries);
  }

  bool _isInternalKey(String key) => key.startsWith(_namespace);

  String _fromInternalKey(String key) => key.replaceFirst(_namespace, '');

  String _toInternalKey(String key) => '$_namespace$key';

  @override
  Future<String?> get(String key) async {
    return await _sharedPreferences.getString(_toInternalKey(key));
  }

  @override
  Future<void> set(String key, String value) async {
    await _sharedPreferences.setString(_toInternalKey(key), value);
  }

  @override
  Future<void> remove(String key) async {
    await _sharedPreferences.remove(_toInternalKey(key));
  }

  @override
  Future<void> clear() async {
    final keys = (await data).keys;
    await Future.wait(keys.map(remove));
  }
}
