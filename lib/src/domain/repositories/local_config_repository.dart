import 'package:local_config/src/domain/entities/local_config_update.dart';
import 'package:local_config/src/domain/entities/local_config_value.dart';

abstract class LocalConfigRepository {
  Map<String, LocalConfigValue> get configs;

  Stream<LocalConfigUpdate> get onConfigUpdated;

  Future<void> setDefaults(Map<String, String> defaultParameters);

  LocalConfigValue? get(String key);

  Future<void> set(String key, String value);

  Future<void> reset(String key);

  Future<void> resetAll();
}
