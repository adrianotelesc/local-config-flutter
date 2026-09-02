import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:local_config/src/presentation/l10n/generated/local_config_localizations.dart';
import 'package:local_config/src/presentation/local_config_routes.dart';
import 'package:local_config/src/presentation/local_config_theme.dart';
import 'package:local_config/src/presentation/screens/config_editing_screen.dart';
import 'package:local_config/src/presentation/screens/config_listing_screen.dart';

/// The entry point widget for Local Config UI.
class LocalConfigEntrypoint extends StatefulWidget {
  /// Creates a entry point for Local Config UI.
  const LocalConfigEntrypoint({super.key});

  @override
  State<LocalConfigEntrypoint> createState() => _LocalConfigEntrypointState();
}

class _LocalConfigEntrypointState extends State<LocalConfigEntrypoint> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Localizations(
      locale: Localizations.maybeLocaleOf(context) ?? const Locale('en'),
      delegates: const [
        LocalConfigLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      child: Theme(
        data: LocalConfigTheme.data,
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
