import 'package:local_config/src/core/model/key_namespace.dart';

abstract class KeyValuePrunePolicy {
  bool shouldRemove({
    required KeyNamespace namespace,
    required MapEntry<String, String> entry,
    required Map<String, String> retained,
  });
}
