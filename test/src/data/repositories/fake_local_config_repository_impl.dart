import 'dart:async';

import 'package:local_config/local_config.dart';
import 'package:local_config/src/domain/entities/local_config_update.dart';
import 'package:local_config/src/domain/repositories/local_config_repository.dart';

class FakeLocalConfigRepositoryImpl implements LocalConfigRepository {
  final _controller = StreamController<LocalConfigUpdate>.broadcast();

  Map<String, LocalConfigValue> _configs = {};

  @override
  Map<String, LocalConfigValue> get configs => _configs;

  @override
  Stream<LocalConfigUpdate> get onConfigUpdated => _controller.stream;

  @override
  LocalConfigValue? get(String key) => _configs[key];

  @override
  Future<void> set(String key, String value) async {
    final current = _configs[key]!;
    _configs[key] = current.withOverride(value);
    _controller.add(LocalConfigUpdate({key}));
  }

  @override
  Future<void> reset(String key) async {
    final current = _configs[key]!;
    _configs[key] = current.withOverride(null);
    _controller.add(LocalConfigUpdate({key}));
  }

  @override
  Future<void> resetAll() async {
    _configs.updateAll((_, v) => v.withOverride(null));
    _controller.add(LocalConfigUpdate(_configs.keys.toSet()));
  }

  @override
  Future<void> setDefaults(Map<String, String> defaults) async {
    _configs = defaults.map(
      (k, v) => MapEntry(
        k,
        LocalConfigValue(
          type: LocalConfigType.infer(v),
          defaultValue: v,
        ),
      ),
    );
  }
}
