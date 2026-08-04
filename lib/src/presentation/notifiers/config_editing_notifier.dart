import 'package:flutter/material.dart';
import 'package:local_config/src/domain/repositories/local_config_repository.dart';
import 'package:local_config/src/presentation/models/config_value.dart';

class ConfigEditingNotifier extends ChangeNotifier {
  ConfigEditingNotifier({
    required LocalConfigRepository configRepo,
  }) : _configRepo = configRepo;

  final LocalConfigRepository _configRepo;

  late final String name;

  late final ConfigValue _configValue;
  ConfigValue get configValue => _configValue;

  String? _initialEditingLocalValue;
  String? get initialEditingLocalValue => _initialEditingLocalValue;

  var _showEditingLocalValue = false;
  bool get showEditingLocalValue => _showEditingLocalValue;
  set showEditingLocalValue(bool value) {
    if (value == _showEditingLocalValue) return;
    _showEditingLocalValue = value;
    notifyListeners();
  }

  var _shouldResetToDefault = false;
  bool get shouldResetToDefault => _shouldResetToDefault;
  set shouldResetToDefault(bool value) {
    if (value == _shouldResetToDefault) return;
    _shouldResetToDefault = value;
    notifyListeners();
  }

  void load(String name) {
    this.name = name;

    final defaultValue = _configRepo.defaults[name];
    if (defaultValue == null) {
      final localValue = _configRepo.locals[name];
      if (localValue == null) return;

      _configValue = ConfigValue(
        defaultValue: localValue,
        localValue: null,
        isCustom: true,
      );

      _showEditingLocalValue = true;

      _initialEditingLocalValue = localValue;

      notifyListeners();
      return;
    }

    final localValue = _configRepo.locals[name];

    _configValue = ConfigValue(
      defaultValue: defaultValue,
      localValue: localValue,
    );

    _showEditingLocalValue = localValue != null;

    _initialEditingLocalValue = _configValue.effectiveValue;

    notifyListeners();
  }

  /// Saves the entry under [newName], which may differ from [name] when
  /// renaming a free-form entry (default-backed entries can't be renamed,
  /// so [newName] is expected to always equal [name] for those).
  void save(final String newName, final String editingLocalValue) {
    if (_shouldResetToDefault) {
      _configRepo.reset(name);
    } else if (_configValue.isCustom && newName != name) {
      _configRepo.reset(name);
      _configRepo.set(newName, editingLocalValue);
    } else {
      _configRepo.set(
        name,
        editingLocalValue,
      );
    }

    _shouldResetToDefault = false;
    notifyListeners();
  }

  /// Whether a default or a local value already exists for [name].
  bool nameExists(String name) => _configRepo.getValue(name) != null;

  /// Creates a new free-form entry.
  Future<void> add(String name, String value) => _configRepo.set(name, value);
}
