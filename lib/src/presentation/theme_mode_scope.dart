import 'package:flutter/widgets.dart';
import 'package:local_config/src/presentation/notifiers/theme_mode_notifier.dart';

/// Exposes the [ThemeModeNotifier] to every screen pushed by
/// [LocalConfigEntrypoint]'s internal Navigator.
class ThemeModeScope extends InheritedNotifier<ThemeModeNotifier> {
  const ThemeModeScope({
    super.key,
    required ThemeModeNotifier themeModeNotifier,
    required super.child,
  }) : super(notifier: themeModeNotifier);

  static ThemeModeNotifier of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<ThemeModeScope>();
    if (scope == null) {
      throw StateError('ThemeModeScope not found in context.');
    }
    return scope.notifier!;
  }
}
