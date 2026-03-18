import 'dart:convert';

import 'package:local_config/src/common/utils/type_converters.dart';

class LocalConfigValue {
  final String defaultValue;

  final String? overriddenValue;

  const LocalConfigValue({required this.defaultValue, this.overriddenValue});

  @override
  int get hashCode => Object.hash(defaultValue, overriddenValue);

  bool get isDefault =>
      overriddenValue == null || overriddenValue == defaultValue;

  bool get isOverridden =>
      overriddenValue != null && overriddenValue != defaultValue;

  LocalConfigType get type => LocalConfigType.inferFromValue(defaultValue);

  String get raw => overriddenValue ?? defaultValue;

  Object get parsed {
    return switch (type) {
      LocalConfigType.boolean => bool.parse(raw),
      LocalConfigType.number => num.parse(raw),
      LocalConfigType.string => raw,
      LocalConfigType.json => jsonDecode(raw),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalConfigValue &&
          defaultValue == other.defaultValue &&
          overriddenValue == other.overriddenValue;

  LocalConfigValue copyWith({String? overriddenValue}) {
    return LocalConfigValue(
      defaultValue: defaultValue,
      overriddenValue: overriddenValue,
    );
  }

  @override
  String toString() =>
      'ConfigValue(default: $defaultValue, overridden: $overriddenValue)';
}

enum LocalConfigType {
  boolean,
  number,
  string,
  json;

  bool get isText =>
      this == LocalConfigType.string || this == LocalConfigType.json;

  static LocalConfigType inferFromValue(String source) {
    if (bool.tryParse(source) != null) return LocalConfigType.boolean;
    if (num.tryParse(source) != null) return LocalConfigType.number;
    if (tryJsonDecode(source) != null) return LocalConfigType.json;
    return LocalConfigType.string;
  }
}
