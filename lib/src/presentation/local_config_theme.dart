import 'package:flutter/material.dart';

abstract final class LocalConfigTheme {
  // Palette transposed straight from Firebase Console's own `--mat-sys-*`
  // Material 3 tokens (light-dark(claro, escuro) pairs copied literally,
  // not generated from a seed color).
  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,

    primary: Color(0xFF0B57D0),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFD3E3FD),
    onPrimaryContainer: Color(0xFF0842A0),
    primaryFixed: Color(0xFFD3E3FD),
    primaryFixedDim: Color(0xFFA8C7FA),
    onPrimaryFixed: Color(0xFF041E49),
    onPrimaryFixedVariant: Color(0xFF0842A0),

    secondary: Color(0xFF00639B),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFC2E7FF),
    onSecondaryContainer: Color(0xFF004A77),
    secondaryFixed: Color(0xFFC2E7FF),
    secondaryFixedDim: Color(0xFF7FCFFF),
    onSecondaryFixed: Color(0xFF001D35),
    onSecondaryFixedVariant: Color(0xFF004A77),

    tertiary: Color(0xFF146C2E),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFC4EED0),
    onTertiaryContainer: Color(0xFF0F5223),
    tertiaryFixed: Color(0xFFC4EED0),
    tertiaryFixedDim: Color(0xFF6DD58C),
    onTertiaryFixed: Color(0xFF072711),
    onTertiaryFixedVariant: Color(0xFF0F5223),

    error: Color(0xFFB3261E),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFF9DEDC),
    onErrorContainer: Color(0xFF8C1D18),

    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF1F1F1F),
    onSurfaceVariant: Color(0xFF444746),
    surfaceDim: Color(0xFFD3DBE5),
    surfaceBright: Color(0xFFFFFFFF),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF8FAFD),
    surfaceContainer: Color(0xFFF0F4F9),
    surfaceContainerHigh: Color(0xFFE9EEF6),
    surfaceContainerHighest: Color(0xFFDDE3EA),
    surfaceTint: Color(0xFF6991D6),

    outline: Color(0xFF747775),
    outlineVariant: Color(0xFFC4C7C5),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF303030),
    onInverseSurface: Color(0xFFF2F2F2),
    inversePrimary: Color(0xFFA8C7FA),
  );

  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,

    primary: Color(0xFFA8C7FA),
    onPrimary: Color(0xFF062E6F),
    primaryContainer: Color(0xFF0842A0),
    onPrimaryContainer: Color(0xFFD3E3FD),
    primaryFixed: Color(0xFFD3E3FD),
    primaryFixedDim: Color(0xFFA8C7FA),
    onPrimaryFixed: Color(0xFF041E49),
    onPrimaryFixedVariant: Color(0xFF0842A0),

    secondary: Color(0xFF7FCFFF),
    onSecondary: Color(0xFF003355),
    secondaryContainer: Color(0xFF004A77),
    onSecondaryContainer: Color(0xFFC2E7FF),
    secondaryFixed: Color(0xFFC2E7FF),
    secondaryFixedDim: Color(0xFF7FCFFF),
    onSecondaryFixed: Color(0xFF001D35),
    onSecondaryFixedVariant: Color(0xFF004A77),

    tertiary: Color(0xFF6DD58C),
    onTertiary: Color(0xFF0A3818),
    tertiaryContainer: Color(0xFF0F5223),
    onTertiaryContainer: Color(0xFFC4EED0),
    tertiaryFixed: Color(0xFFC4EED0),
    tertiaryFixedDim: Color(0xFF6DD58C),
    onTertiaryFixed: Color(0xFF072711),
    onTertiaryFixedVariant: Color(0xFF0F5223),

    error: Color(0xFFF2B8B5),
    onError: Color(0xFF601410),
    errorContainer: Color(0xFF8C1D18),
    onErrorContainer: Color(0xFFF9DEDC),

    surface: Color(0xFF131314),
    onSurface: Color(0xFFE3E3E3),
    onSurfaceVariant: Color(0xFFC4C7C5),
    surfaceDim: Color(0xFF131313),
    surfaceBright: Color(0xFF37393B),
    surfaceContainerLowest: Color(0xFF0E0E0E),
    surfaceContainerLow: Color(0xFF1B1B1B),
    surfaceContainer: Color(0xFF1E1F20),
    surfaceContainerHigh: Color(0xFF282A2C),
    surfaceContainerHighest: Color(0xFF333537),
    surfaceTint: Color(0xFFD1E1FF),

    outline: Color(0xFF8E918F),
    outlineVariant: Color(0xFF444746),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFE3E3E3),
    onInverseSurface: Color(0xFF303030),
    inversePrimary: Color(0xFF0B57D0),
  );

  // Warning/success accents transposed from Firebase Console's auxiliary
  // status tokens. Rows highlighted as "changed" cover a full-width list
  // tile rather than a small badge, so the console's solid containers are
  // toned down to a soft alpha tint here to keep long lists scannable.
  static ExtendedColorScheme get _lightExtendedColors => ExtendedColorScheme(
    warning: const Color(0xFF8F4E06),
    onWarning: const Color(0xFFFFFFFF),
    warningContainer: const Color(0xFF8F4E06).withAlpha(0x14),
    onWarningContainer: const Color(0xFF8F4E06).withAlpha(0x4D),
    success: const Color(0xFF006C35),
    onSuccess: const Color(0xFFFFFFFF),
    successContainer: const Color(0xFF006C35).withAlpha(0x14),
    onSuccessContainer: const Color(0xFF006C35).withAlpha(0x4D),
  );

  static ExtendedColorScheme get _darkExtendedColors => ExtendedColorScheme(
    warning: const Color(0xFFFCBD00),
    onWarning: const Color(0xFF4D2600),
    warningContainer: const Color(0xFFFCBD00).withAlpha(0x14),
    onWarningContainer: const Color(0xFFFCBD00).withAlpha(0x4D),
    success: const Color(0xFF80DA88),
    onSuccess: const Color(0xFF00381F),
    successContainer: const Color(0xFF80DA88).withAlpha(0x14),
    onSuccessContainer: const Color(0xFF80DA88).withAlpha(0x4D),
  );

  static ThemeData _base(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    fontFamily: 'GoogleSans',
    package: 'local_config',
    inputDecorationTheme: _inputDecorationTheme(colorScheme),
  );

  static InputDecorationTheme _inputDecorationTheme(ColorScheme colorScheme) =>
      InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.onSurface.withAlpha(23)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
      );

  static ThemeData _buildData(
    ColorScheme colorScheme,
    ExtendedColorScheme extendedColors,
  ) {
    final base = _base(colorScheme);

    return base.copyWith(
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      dividerTheme: base.dividerTheme.copyWith(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      dropdownMenuTheme: base.dropdownMenuTheme.copyWith(
        textStyle: base.dropdownMenuTheme.textStyle?.copyWith(
          color: colorScheme.onSurface,
        ),
        menuStyle: MenuStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 0),
          ),
        ),
      ),
      bottomSheetTheme: base.bottomSheetTheme.copyWith(
        shape: RoundedRectangleBorder(),
      ),
      popupMenuTheme: base.popupMenuTheme.copyWith(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      searchBarTheme: base.searchBarTheme.copyWith(
        shadowColor: const WidgetStatePropertyAll(Colors.transparent),
        shape: WidgetStateProperty.fromMap({
          WidgetState.focused: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: colorScheme.primary, width: 2),
          ),
          WidgetState.any: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        }),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: base.filledButtonTheme.style?.copyWith(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: base.filledButtonTheme.style?.copyWith(
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.onSurfaceVariant,
        textColor: colorScheme.onSurface,
        selectedColor: colorScheme.onSecondaryContainer,
        selectedTileColor: colorScheme.secondaryContainer,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.onPrimary
              : colorScheme.outline,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
        ),
      ),
      textSelectionTheme: base.textSelectionTheme.copyWith(
        cursorColor: colorScheme.primary,
        selectionColor: colorScheme.primary.withAlpha(102),
        selectionHandleColor: colorScheme.primary,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colorScheme.onSurfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        selectedColor: colorScheme.secondaryContainer,
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        side: BorderSide(color: colorScheme.outlineVariant),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
      ),
      extensions: [
        extendedColors,
        ExtendedTextTheme(
          codeBodyLarge: base.textTheme.bodyLarge?.copyWith(
            fontFamily: 'GoogleSansCode',
          ),
          codeBodyMedium: base.textTheme.bodyMedium?.copyWith(
            fontFamily: 'GoogleSansCode',
          ),
        ),
      ],
    );
  }

  static ThemeData get light => _buildData(_lightColorScheme, _lightExtendedColors);

  static ThemeData get dark => _buildData(_darkColorScheme, _darkExtendedColors);

  /// Resolves the theme matching [brightness], mirroring the light/dark
  /// modes Firebase Console itself supports.
  static ThemeData resolve(Brightness brightness) =>
      brightness == Brightness.dark ? dark : light;
}

class ExtendedColorScheme extends ThemeExtension<ExtendedColorScheme> {
  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;
  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;

  ExtendedColorScheme({
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
  });

  @override
  ThemeExtension<ExtendedColorScheme> copyWith({
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
  }) {
    return ExtendedColorScheme(
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
    );
  }

  @override
  ThemeExtension<ExtendedColorScheme> lerp(
    covariant ThemeExtension<ExtendedColorScheme>? other,
    double t,
  ) {
    if (other is! ExtendedColorScheme) {
      return this;
    }

    return ExtendedColorScheme(
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
      onWarningContainer: Color.lerp(
        onWarningContainer,
        other.onWarningContainer,
        t,
      )!,
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer: Color.lerp(
        successContainer,
        other.successContainer,
        t,
      )!,
      onSuccessContainer: Color.lerp(
        onSuccessContainer,
        other.onSuccessContainer,
        t,
      )!,
    );
  }
}

class ExtendedTextTheme extends ThemeExtension<ExtendedTextTheme> {
  final TextStyle? codeBodyLarge;
  final TextStyle? codeBodyMedium;

  ExtendedTextTheme({
    this.codeBodyLarge,
    this.codeBodyMedium,
  });

  @override
  ThemeExtension<ExtendedTextTheme> copyWith({
    TextStyle? codeBodyLarge,
    TextStyle? codeBodyMedium,
  }) {
    return ExtendedTextTheme(
      codeBodyLarge: codeBodyLarge ?? this.codeBodyLarge,
      codeBodyMedium: codeBodyMedium ?? this.codeBodyMedium,
    );
  }

  @override
  ThemeExtension<ExtendedTextTheme> lerp(
    covariant ThemeExtension<ExtendedTextTheme>? other,
    double t,
  ) {
    if (other is! ExtendedTextTheme) {
      return this;
    }

    return ExtendedTextTheme(
      codeBodyLarge: TextStyle.lerp(codeBodyLarge, other.codeBodyLarge, t)!,
      codeBodyMedium: TextStyle.lerp(codeBodyMedium, other.codeBodyMedium, t)!,
    );
  }
}

extension BuildContextThemeExtension on BuildContext {
  ExtendedColorScheme get extendedColorScheme {
    final extendedColors = Theme.of(this).extension<ExtendedColorScheme>();
    if (extendedColors == null) {
      throw StateError('ExtendedColorScheme not found in the theme context.');
    }
    return extendedColors;
  }

  ExtendedTextTheme get extendedTextTheme {
    final extendedText = Theme.of(this).extension<ExtendedTextTheme>();
    if (extendedText == null) {
      throw StateError('ExtendedTextTheme not found in the theme context.');
    }
    return extendedText;
  }
}
