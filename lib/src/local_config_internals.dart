import 'package:local_config/src/core/persistence/key_value_storage.dart';
import 'package:local_config/src/data/repositories/noop_local_config_repository_impl.dart';
import 'package:local_config/src/domain/repositories/local_config_repository.dart';

LocalConfigRepository configRepo = NoopLocalConfigRepositoryImpl();

/// Storage for Local Config UI preferences (e.g. the chosen theme mode),
/// scoped separately from [configRepo] so it's unaffected by config resets.
/// Null until [LocalConfig.initialize] runs.
KeyValueStorage? uiPreferencesStorage;
