import 'dart:convert';

import 'package:flutter/foundation.dart';

Map<String, dynamic>? tryJsonDecode(String source) {
  try {
    return jsonDecode(source);
  } catch (e) {
    assert(() {
      debugPrint('JSON decode failed for $source → $e');
      return true;
    }());
    return null;
  }
}

String? tryJsonEncode(Object object) {
  try {
    return jsonEncode(object);
  } catch (e) {
    assert(() {
      debugPrint('JSON encode failed for $object → $e');
      return true;
    }());
    return null;
  }
}
