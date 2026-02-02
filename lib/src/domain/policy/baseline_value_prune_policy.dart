import 'package:local_config/src/core/model/key_namespace.dart';
import 'package:local_config/src/domain/policy/prune_policy.dart';

class BaselineValuePrunePolicy implements KeyValuePrunePolicy {
  @override
  bool shouldRemove({
    required KeyNamespace namespace,
    required MapEntry<String, String> entry,
    required Map<String, String> retained,
  }) => retained[namespace.strip(entry.key)] == entry.value;
}
