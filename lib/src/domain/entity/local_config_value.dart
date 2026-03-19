import 'package:local_config/src/common/utils/type_converters.dart';

class LocalConfigValue {
  final LocalConfigType type;

  final String defaultValue;

  final String? overrideValue;

  LocalConfigValue({
    required this.type,
    required this.defaultValue,
    this.overrideValue,
  }) : assert(
         type == LocalConfigType.infer(defaultValue),
         'default value type must match the inferred type.',
       ),
       assert(
         overrideValue == null || type == LocalConfigType.infer(overrideValue),
         'override value type must match the inferred type.',
       );

  bool get isDefault => overrideValue == null || overrideValue == defaultValue;

  bool get hasOverride =>
      overrideValue != null && overrideValue != defaultValue;

  String get asString => overrideValue ?? defaultValue;

  bool? get asBool => tryParseBool(asString);

  double? get asDouble => double.tryParse(asString);

  int? get asInt => int.tryParse(asString);

  Object? get asJson => tryJsonDecode(asString);

  LocalConfigValue setOverride(String? value) => LocalConfigValue(
    type: type,
    defaultValue: defaultValue,
    overrideValue: value,
  );

  @override
  int get hashCode => Object.hash(defaultValue, overrideValue);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalConfigValue &&
          defaultValue == other.defaultValue &&
          overrideValue == other.overrideValue;

  @override
  String toString() =>
      'ConfigValue(default: $defaultValue, override: $overrideValue)';
}

enum LocalConfigType {
  boolean,
  number,
  string,
  json;

  bool get isTextBased =>
      this == LocalConfigType.string || this == LocalConfigType.json;

  static LocalConfigType infer(String source) {
    if (tryParseBool(source) != null) return LocalConfigType.boolean;
    if (num.tryParse(source) != null) return LocalConfigType.number;
    if (tryJsonDecode(source) != null) return LocalConfigType.json;
    return LocalConfigType.string;
  }
}
