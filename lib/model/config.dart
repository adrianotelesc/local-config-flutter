import 'package:local_config/extension/string_parsing_extension.dart';

class Config {
  final String value;
  final String? changedValue;

  ConfigType get type {
    if (value.asBool != null) return ConfigType.boolean;
    if (value.asDouble != null) return ConfigType.number;
    if (value.asJson != null) return ConfigType.json;
    return ConfigType.string;
  }

  const Config({
    required this.value,
    this.changedValue,
  });

  Config copyWith({
    String? value,
    String? changedValue,
  }) {
    return Config(
      value: value ?? this.value,
      changedValue: changedValue,
    );
  }
}

enum ConfigType {
  boolean,
  number,
  string,
  json;

  bool get isText => this == ConfigType.string || this == ConfigType.json;
}
