bool isValidStorageKey(String value) =>
    value.isNotEmpty && RegExp(r'^[a-z0-9_]+$').hasMatch(value);
