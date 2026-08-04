import 'dart:async';

import 'package:local_config/src/common/extensions/map_extension.dart';
import 'package:local_config/src/common/utils/type_converters.dart';
import 'package:local_config/src/core/persistence/key_value_storage.dart';
import 'package:local_config/src/domain/entities/local_config_update.dart';
import 'package:local_config/src/domain/entities/local_config_value.dart';
import 'package:local_config/src/domain/repositories/local_config_repository.dart';

class LocalConfigRepositoryImpl implements LocalConfigRepository {
  LocalConfigRepositoryImpl({required KeyValueStorage storage})
    : _storage = storage;

  final KeyValueStorage _storage;

  @override
  Map<String, LocalConfigValue> get all {
    Map<String, LocalConfigValue> all = {};

    for (final key in _defaults.keys) {
      final value = getValue(key);
      if (value == null) continue;

      all[key] = value;
    }

    for (final key in _locals.keys) {
      if (_defaults.containsKey(key)) continue;

      final value = getValue(key);
      if (value == null) continue;

      all[key] = value;
    }

    return all;
  }

  @override
  Map<String, String> get defaults => _defaults;
  var _defaults = <String, String>{};

  @override
  Map<String, String> get locals => _locals;
  var _locals = <String, String>{};

  @override
  Stream<LocalConfigUpdate> get onConfigUpdated => _controller.stream;
  final _controller = StreamController<LocalConfigUpdate>.broadcast();

  @override
  Future<void> setDefaults(Map<String, String> defaults) async {
    _defaults = defaults;
    final locals = await _storage.all;

    final retainedLocals = locals.where((key, localValue) {
      final defaultValue = defaults[key];
      // Keys with no matching default are free-form entries, not tied to
      // the app's schema, so they're always retained.
      if (defaultValue == null) return true;

      final parsedDefault = parse(defaultValue);
      final parsedLocal = parse(localValue);

      return parsedDefault.runtimeType == parsedLocal.runtimeType &&
          parsedDefault != parsedLocal;
    });

    await _storage.prune(retainedLocals.keys.toSet());

    _locals = retainedLocals;
  }

  @override
  LocalConfigValue? getValue(String key) {
    final defaultValue = _defaults[key];
    if (defaultValue == null) {
      final localValue = _locals[key];
      if (localValue == null) return null;

      return LocalConfigValue(
        value: localValue,
        source: ValueSource.valueLocal,
      );
    }

    final localValue = _locals[key];
    if (localValue != null && localValue != defaultValue) {
      return LocalConfigValue(
        value: localValue,
        source: ValueSource.valueLocal,
      );
    }

    return LocalConfigValue(
      value: defaultValue,
      source: ValueSource.valueDefault,
    );
  }

  @override
  Future<void> set(String key, String value) async {
    final defaultValue = _defaults[key];

    // Listeners only need the in-memory state, which is already up to date
    // here, so they're notified before awaiting the storage round-trip
    // instead of after — otherwise UI updates (e.g. the listing screen
    // refreshing after a save) are delayed by however long the platform
    // channel write takes, which is especially noticeable with secure
    // storage.
    if (defaultValue == null || value != defaultValue) {
      _locals[key] = value;
      _controller.add(LocalConfigUpdate({key}));
      await _storage.setString(key, value);
    } else {
      _locals.remove(key);
      _controller.add(LocalConfigUpdate({key}));
      await _storage.remove(key);
    }
  }

  @override
  Future<void> reset(String key) async {
    _locals.remove(key);
    _controller.add(LocalConfigUpdate({key}));

    await _storage.remove(key);
  }

  @override
  Future<void> resetAll() async {
    final updatedKeys = _locals.keys.toSet();
    _locals.clear();
    _controller.add(LocalConfigUpdate(updatedKeys));

    await Future.wait(updatedKeys.map(_storage.remove));
  }
}
