library firebase_local_config;

import 'package:firebase_local_config/source/config_source.dart';
import 'package:firebase_local_config/source/shared_preferences_config_source.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class FirebaseLocalConfig {
  FirebaseLocalConfig._();

  static final instance = FirebaseLocalConfig._();

  final ConfigSource _localConfig = SharedPreferencesConfigSource();

  Map<String, String> _values = {};

  Future<void> initialize(Map<String, RemoteConfigValue> values) async {
    await _localConfig.initialize();

    _values = values.map((key, value) {
      return MapEntry(key, value.asString());
    });
  }

  bool? getBool(String key) {
    return _localConfig.getBool(key);
  }

  int? getInt(String key) {
    return _localConfig.getInt(key);
  }

  double? getDouble(String key) {
    return _localConfig.getDouble(key);
  }

  String? getString(String key) {
    return _localConfig.getString(key);
  }

  Future<void> setBool(String key, bool value) async {
    await _localConfig.setBool(key, value);
  }

  Future<void> setInt(String key, int value) async {
    await _localConfig.setInt(key, value);
  }

  Future<void> setDouble(String key, double value) async {
    await _localConfig.setDouble(key, value);
  }

  Future<void> setString(String key, String value) async {
    await _localConfig.setString(key, value);
  }

  Widget getLocalConfigScreen() {
    final localConfigs = _values.entries.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Local Config'),
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
