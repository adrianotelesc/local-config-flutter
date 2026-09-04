import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:local_config/src/local_config_internals.dart';
import 'package:local_config/src/presentation/l10n/generated/local_config_localizations.dart';
import 'package:local_config/src/presentation/local_config_routes.dart';
import 'package:local_config/src/presentation/local_config_theme.dart';
import 'package:local_config/src/presentation/notifiers/theme_mode_notifier.dart';
import 'package:local_config/src/presentation/screens/config_editing_screen.dart';
import 'package:local_config/src/presentation/screens/config_listing_screen.dart';
import 'package:local_config/src/presentation/theme_mode_scope.dart';

/// The entry point widget for Local Config UI.
class LocalConfigEntrypoint extends StatefulWidget {
  /// Creates a entry point for Local Config UI.
  const LocalConfigEntrypoint({super.key});

  @override
  State<LocalConfigEntrypoint> createState() => _LocalConfigEntrypointState();
}

class _LocalConfigEntrypointState extends State<LocalConfigEntrypoint> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  late final _themeModeNotifier = ThemeModeNotifier(
    storage: uiPreferencesStorage,
  );

  @override
  void dispose() {
    _themeModeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final platformBrightness = MediaQuery.platformBrightnessOf(context);

    return Localizations(
      locale: Localizations.maybeLocaleOf(context) ?? const Locale('en'),
      delegates: const [
        LocalConfigLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      child: ListenableBuilder(
        listenable: _themeModeNotifier,
        builder: (context, child) {
          final brightness = _themeModeNotifier.themeMode.resolve(
            platformBrightness,
          );

          return ThemeModeScope(
            themeModeNotifier: _themeModeNotifier,
            child: Theme(
              data: LocalConfigTheme.resolve(brightness),
              child: child!,
            ),
          );
        },
        child: NavigatorPopHandler<Object?>(
          onPopWithResult: (result) {
            _navigatorKey.currentState?.pop(result);
          },
          child: Navigator(
            key: _navigatorKey,
            initialRoute: LocalConfigRoutes.configList,
            onGenerateRoute: (settings) {
              return switch (settings.name) {
                LocalConfigRoutes.configList => MaterialPageRoute(
                  builder: (_) => const ConfigListingScreen(),
                ),
                LocalConfigRoutes.configEdit => MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (_) => ConfigEditingScreen(
                    name: settings.arguments.toString(),
                  ),
                ),
                LocalConfigRoutes.configAdd => MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (_) => const ConfigEditingScreen(),
                ),
                _ => null,
              };
            },
          ),
        ),
      ),
    );
  }
}
