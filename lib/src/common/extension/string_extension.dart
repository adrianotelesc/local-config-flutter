import 'dart:convert';

extension StringExtension on String {
  Map<String, dynamic>? toMapOrNull() {
    try {
      return jsonDecode(this);
    } catch (_) {
      return null;
    }
  }

  bool? toBoolOrNull() => bool.tryParse(this);

  int? toStrictIntOrNull() {
    if (RegExp(r'^0\d+$').hasMatch(this)) {
      return null;
    }

    return int.tryParse(this);
  }

  double? toStrictDoubleOrNull() {
    if (RegExp(r'^0\d+(\.\d+)?$').hasMatch(this)) {
      return null;
    }

    return double.tryParse(this);
  }

  bool containsInsensitive(String other) =>
      toLowerCase().contains(other.toLowerCase());
}
