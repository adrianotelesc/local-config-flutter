import 'package:local_config/src/common/utils/type_converters.dart';
import 'package:local_config/src/infrastructure/vo/local_config_settings.dart';
import 'package:local_config/src/domain/entity/local_config_update.dart';
import 'package:local_config/src/domain/entity/local_config_value.dart';
import 'package:local_config/src/infrastructure/di/internal_service_locator.dart';
import 'package:local_config/src/infrastructure/persistence/scoped_key_value_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_config/src/core/persistence/key_value_storage.dart';
import 'package:local_config/src/data/repository/local_config_repository_impl.dart';
import 'package:local_config/src/domain/repository/local_config_repository.dart';
import 'package:local_config/src/infrastructure/persistence/shared_preferences_key_value_storage.dart';

final class LocalConfig {
  static const _keyNamespaceBase = 'local_config';

  static final instance = LocalConfig._();

  LocalConfig._();

  var _initialized = false;

  Map<String, LocalConfigValue> get all =>
      _repo.all.map((key, value) => MapEntry(key, value));

  LocalConfigRepository get _repo {
    ensureInitialized();
    return serviceLocator.get<LocalConfigRepository>();
  }

  Stream<LocalConfigUpdate> get onConfigUpdated => _repo.onConfigUpdated;

  Future<void> initialize({
    final LocalConfigSettings configSettings = const LocalConfigSettings(),
  }) async {
    if (_initialized) {
      throw StateError('LocalConfig already initialized');
    }

    serviceLocator
      ..registerFactory<KeyValueStorage>(
        () => ScopedKeyValueStorage(
          namespace: KeyNamespace(
            base: _keyNamespaceBase,
            segments: configSettings.keyNamespaceSegments,
          ),
          delegate:
              configSettings.keyValueStorage ??
              SharedPreferencesKeyValueStorage(
                sharedPreferences: SharedPreferencesAsync(),
              ),
        ),
      )
      ..registerLazySingleton<LocalConfigRepository>(
        () => LocalConfigRepositoryImpl(
          storage: serviceLocator.get<KeyValueStorage>(),
        ),
      );

    _initialized = true;
  }

  void ensureInitialized() {
    if (!_initialized) {
      throw StateError('LocalConfig not initialized');
    }
  }

  Future<void> setDefaults(Map<String, Object> defaults) => _repo.setDefaults(
    defaults.map((key, value) => MapEntry(key, stringify(value))),
  );

  bool? getBool(String key) => getValue(key)?.asBool;

  LocalConfigValue? getValue(String key) => _repo.get(key);

  double? getDouble(String key) => getValue(key)?.asDouble;

  int? getInt(String key) => getValue(key)?.asInt;

  String? getString(String key) => getValue(key)?.asString;

  Future<void> clear() => _repo.clear();
}
