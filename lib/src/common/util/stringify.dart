import 'package:local_config/src/common/util/json_safe_convert.dart';

String stringify(Object object) {
  if (object is String) return object;

  if (object is Map || object is List) {
    return tryJsonEncode(object) ?? object.toString();
  }

  return object.toString();
}
