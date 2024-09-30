library firebase_local_config;

import 'package:firebase_local_config/source/config_source.dart';
import 'package:firebase_local_config/source/shared_preferences_config_source.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class FirebaseLocalConfig {
  FirebaseLocalConfig._();

  static final instance = FirebaseLocalConfig._();

  final ConfigSource _localConfig = SharedPreferencesConfigSource();

  Map<String, dynamic> _localValues = {};

  Future<void> initialize(Map<String, RemoteConfigValue> remoteValues) async {
    await _localConfig.initialize();

    _localValues = remoteValues.map((key, value) {
      if (value.asBool() != RemoteConfigValue.defaultValueForBool) {
        return MapEntry(key, value.asBool());
      } else if (value.asInt() != RemoteConfigValue.defaultValueForInt) {
        return MapEntry(key, value.asInt());
      } else if (value.asDouble() != RemoteConfigValue.defaultValueForDouble) {
        return MapEntry(key, value.asDouble());
      } else if (value.asString() != RemoteConfigValue.defaultValueForString) {
        return MapEntry(key, value.asString());
      } else {
        return MapEntry(key, null);
      }
    });
    _localValues.removeWhere((key, value) => value == null);
  }

  bool? getBool(String key) {
    final localValue = _localValues[key];
    if (localValue is bool) {
      return localValue;
    }

    return _localConfig.getBool(key);
  }

  int? getInt(String key) {
    final localValue = _localValues[key];
    if (localValue is int) {
      return localValue;
    }

    return _localConfig.getInt(key);
  }

  double? getDouble(String key) {
    final localValue = _localValues[key];
    if (localValue is double) {
      return localValue;
    }

    return _localConfig.getDouble(key);
  }

  String? getString(String key) {
    final localValue = _localValues[key];
    if (localValue is String) {
      return localValue;
    }

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
    final localConfigs = _localValues.entries.toList();
    return Scaffold(
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(localConfigs[index].key),
            subtitle: Text(localConfigs[index].value),
          );
        },
      ),
    );
  }
}
