import 'package:local_config/src/core/persistence/key_value_storage.dart';
import 'package:local_config/src/data/repositories/noop_local_config_repository_impl.dart';
import 'package:local_config/src/domain/repositories/local_config_repository.dart';

LocalConfigRepository configRepo = NoopLocalConfigRepositoryImpl();

/// Storage for Local Config UI preferences (e.g. the chosen theme mode),
/// scoped separately from [configRepo] so it's unaffected by config resets.
/// Null until [LocalConfig.initialize] runs.
KeyValueStorage? uiPreferencesStorage;

/// Seed (0.0–1.0) used to pick the "local value" chip's accent color from
/// `LocalConfigTheme.conditionAccentPalette`, chosen once when
/// [LocalConfig.initialize] runs — mirrors picking a color when creating a
/// Firebase Remote Config condition, except there's no per-entry UI here,
/// so every override in the session shares this one random accent.
/// Null until [LocalConfig.initialize] runs.
double? sessionConditionSeed;
