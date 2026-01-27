import 'package:local_config/src/common/extension/string_extension.dart';

class ConfigValue {
  final String defaultValue;

  final String? overriddenValue;

  const ConfigValue({required this.defaultValue, this.overriddenValue});

  @override
  int get hashCode => Object.hash(defaultValue, overriddenValue);

  bool get isDefault =>
      overriddenValue == null || overriddenValue == defaultValue;

  bool get isOverridden =>
      overriddenValue != null && overriddenValue != defaultValue;

  ConfigType get type => ConfigType.inferFromValue(defaultValue);

  String get value => overriddenValue ?? defaultValue;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfigValue &&
          defaultValue == other.defaultValue &&
          overriddenValue == other.overriddenValue;

  ConfigValue copyWith({String? overriddenValue}) {
    return ConfigValue(
      defaultValue: defaultValue,
      overriddenValue: overriddenValue,
    );
  }

  @override
  String toString() =>
      'ConfigValue(default: $defaultValue, overridden: $overriddenValue)';
}

enum ConfigType {
  boolean,
  number,
  string,
  json;

  bool get isText => this == ConfigType.string || this == ConfigType.json;

  static ConfigType inferFromValue(String source) {
    if (source.toBoolOrNull() != null) return ConfigType.boolean;
    if (source.toStrictDoubleOrNull() != null) return ConfigType.number;
    if (source.toMapOrNull() != null) return ConfigType.json;
    return ConfigType.string;
  }
}
