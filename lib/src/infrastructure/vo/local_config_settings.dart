import 'package:local_config/src/core/persistence/key_value_storage.dart';

class LocalConfigSettings {
  final List<String> keyNamespaceSegments;
  final KeyValueStorage? keyValueStorage;

  const LocalConfigSettings({
    this.keyNamespaceSegments = const [],
    this.keyValueStorage,
  });
}
