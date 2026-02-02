import 'package:local_config/src/core/model/key_namespace.dart';
import 'package:local_config/src/domain/policy/prune_policy.dart';

class CompositePrunePolicy implements KeyValuePrunePolicy {
  final List<KeyValuePrunePolicy> policies;

  CompositePrunePolicy({required this.policies});

  @override
  bool shouldRemove({
    required KeyNamespace namespace,
    required MapEntry<String, String> entry,
    required Map<String, String> retained,
  }) => policies.any(
    (policy) => policy.shouldRemove(
      namespace: namespace,
      entry: entry,
      retained: retained,
    ),
  );
}
