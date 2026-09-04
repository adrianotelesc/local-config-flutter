import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_config/src/presentation/notifiers/theme_mode_notifier.dart';

import '../../infra/persistence/fake_key_value_storage.dart';

void main() {
  late FakeKeyValueStorage storage;

  setUp(() {
    storage = FakeKeyValueStorage();
  });

  test('defaults to system when nothing is persisted', () {
    final notifier = ThemeModeNotifier(storage: storage);

    expect(notifier.themeMode, ThemeMode.system);
  });

  test('restores a previously persisted theme mode', () async {
    await storage.setString('theme_mode', ThemeMode.dark.name);

    final notifier = ThemeModeNotifier(storage: storage);
    await Future.delayed(Duration.zero);

    expect(notifier.themeMode, ThemeMode.dark);
  });

  test('setThemeMode updates and persists the value', () async {
    final notifier = ThemeModeNotifier(storage: storage);

    await notifier.setThemeMode(ThemeMode.light);

    expect(notifier.themeMode, ThemeMode.light);
    expect(await storage.getString('theme_mode'), ThemeMode.light.name);
  });

  test('setThemeMode notifies listeners only when the mode changes', () async {
    final notifier = ThemeModeNotifier(storage: storage);
    var notifications = 0;
    notifier.addListener(() => notifications++);

    await notifier.setThemeMode(ThemeMode.system);
    expect(notifications, 0);

    await notifier.setThemeMode(ThemeMode.dark);
    expect(notifications, 1);
  });

  test('works without a storage backend', () async {
    final notifier = ThemeModeNotifier();

    await notifier.setThemeMode(ThemeMode.dark);

    expect(notifier.themeMode, ThemeMode.dark);
  });

  group('ThemeModeBrightness', () {
    test('system resolves to the platform brightness', () {
      expect(
        ThemeMode.system.resolve(Brightness.dark),
        Brightness.dark,
      );
      expect(
        ThemeMode.system.resolve(Brightness.light),
        Brightness.light,
      );
    });

    test('light and dark resolve regardless of platform brightness', () {
      expect(ThemeMode.light.resolve(Brightness.dark), Brightness.light);
      expect(ThemeMode.dark.resolve(Brightness.light), Brightness.dark);
    });
  });
}
