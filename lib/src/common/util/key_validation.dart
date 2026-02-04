final _validKeyPattern = RegExp(r'^[a-zA-Z0-9_.-]+$');

void keyValidate(String key) {
  if (key.isEmpty || !_validKeyPattern.hasMatch(key)) {
    throw ArgumentError.value(
      key,
      'key',
      'Invalid config key. Allowed: a-z A-Z 0-9 _ - .',
    );
  }
}
