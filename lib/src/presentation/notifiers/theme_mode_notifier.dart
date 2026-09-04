import 'package:flutter/material.dart';
import 'package:local_config/src/core/persistence/key_value_storage.dart';

/// Tracks the user's preferred [ThemeMode] for the Local Config UI,
/// persisting it through the same [KeyValueStorage] the host app already
/// configured for Local Config (so no extra dependency is required).
class ThemeModeNotifier extends ChangeNotifier {
  static const _storageKey = 'theme_mode';

  final KeyValueStorage? _storage;

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  ThemeModeNotifier({KeyValueStorage? storage}) : _storage = storage {
    _restore();
  }

  Future<void> _restore() async {
    final stored = await _storage?.getString(_storageKey);
    final restored = ThemeMode.values
        .where((mode) => mode.name == stored)
        .firstOrNull;

    if (restored != null && restored != _themeMode) {
      _themeMode = restored;
      notifyListeners();
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (mode == _themeMode) return;

    _themeMode = mode;
    notifyListeners();

    await _storage?.setString(_storageKey, mode.name);
  }
}

extension ThemeModeBrightness on ThemeMode {
  Brightness resolve(Brightness platformBrightness) => switch (this) {
    ThemeMode.system => platformBrightness,
    ThemeMode.light => Brightness.light,
    ThemeMode.dark => Brightness.dark,
  };
}
