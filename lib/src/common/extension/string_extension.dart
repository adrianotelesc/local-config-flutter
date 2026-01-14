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

  double? toDoubleOrNull() => double.tryParse(this);

  int? toIntOrNull() => int.tryParse(this);

  bool containsInsensitive(String other) =>
      toLowerCase().contains(other.toLowerCase());
}
