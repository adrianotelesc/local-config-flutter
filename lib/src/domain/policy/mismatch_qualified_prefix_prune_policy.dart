import 'package:local_config/src/core/model/key_namespace.dart';
import 'package:local_config/src/domain/policy/prune_policy.dart';

class MismatchQualifiedPrefixPrunePolicy implements KeyValuePrunePolicy {
  @override
  bool shouldRemove({
    required KeyNamespace namespace,
    required MapEntry<String, String> entry,
    required Map<String, String> retained,
  }) => !namespace.matchesQualified(entry.key);
}
