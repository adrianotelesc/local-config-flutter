import 'package:local_config/core/storage/key_value_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesStore extends KeyValueStore {
  final SharedPreferencesAsync _sharedPreferencesAsync;

  SharedPreferencesStore({
    required SharedPreferencesAsync sharedPreferencesAsync,
  }) : _sharedPreferencesAsync = sharedPreferencesAsync;

  @override
  Future<Map<String, Object?>> get all => _sharedPreferencesAsync.getAll();

  @override
  Future<String?> getString(String key) =>
      _sharedPreferencesAsync.getString(key);

  @override
  Future<void> setString(String key, String value) =>
      _sharedPreferencesAsync.setString(key, value);

  @override
  Future<void> remove(String key) => _sharedPreferencesAsync.remove(key);
}
