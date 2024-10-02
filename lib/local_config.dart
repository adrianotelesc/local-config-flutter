library firebase_local_config;

import 'package:firebase_local_config/preferences/preferences_delegate.dart';
import 'package:firebase_local_config/preferences/shared_preferences_delegate.dart';
import 'package:flutter/material.dart';

class LocalConfig {
  LocalConfig._();

  static final instance = LocalConfig._();

  final PreferencesDelegate _preferencesDelegate = SharedPreferencesDelegate();

  Map<String, String> _configs = {};

  void initialize({required Map<String, String> configs}) {
    _configs = configs;
  }

  Future<bool?> getBool(String key) async {
    final config = await _preferencesDelegate.getPreference(key);
    if (config == null) return null;

    return bool.tryParse(config);
  }

  Future<int?> getInt(String key) async {
    final config = await _preferencesDelegate.getPreference(key);
    if (config == null) return null;

    return int.tryParse(config);
  }

  Future<double?> getDouble(String key) async {
    final config = await _preferencesDelegate.getPreference(key);
    if (config == null) return null;

    return double.tryParse(config);
  }

  Future<String?> getString(String key) async {
    return await _preferencesDelegate.getPreference(key);
  }

  Future<void> setBool(String key, bool value) async {
    await _preferencesDelegate.setPreference(key, value.toString());
  }

  Future<void> setInt(String key, int value) async {
    await _preferencesDelegate.setPreference(key, value.toString());
  }

  Future<void> setDouble(String key, double value) async {
    await _preferencesDelegate.setPreference(key, value.toString());
  }

  Future<void> setString(String key, String value) async {
    await _preferencesDelegate.setPreference(key, value.toString());
  }

  Widget getLocalConfigsScreen() {
    final localConfigs = _configs.entries.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Config'),
      ),
      body: ListView.builder(
        itemCount: localConfigs.length,
        itemBuilder: (context, index) {
          final entry = localConfigs[index];

          String type = 'String';
          if (bool.tryParse(entry.value) != null) {
            type = 'bool';
          } else if (int.tryParse(entry.value) != null) {
            type = 'int';
          } else if (double.tryParse(entry.value) != null) {
            type = 'double';
          }

          return InkWell(
            child: ListTile(
              title: Text(entry.key),
              subtitle: Text(type),
              trailing: Text(entry.value),
            ),
            onTap: () {},
          );
        },
      ),
    );
  }
}
