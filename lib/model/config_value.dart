class ConfigValue {
  final String _value;
  final ConfigValueType type;

  const ConfigValue(
    this._value,
    this.type,
  );

  bool? get asBool => bool.tryParse(_value);
  double? get asDouble => double.tryParse(_value);
  int? get asInt => int.tryParse(_value);
  String get asString => _value;
}

enum ConfigValueType {
  boolType,
  intType,
  doubleType,
  stringType,
  jsonType;

  bool get isText => [stringType, jsonType].contains(this);
}
