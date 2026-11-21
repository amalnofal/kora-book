import 'package:material_ui/material_ui.dart';

import 'app_colors.dart';
import 'app_dimens.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light({required String fontFamily}) =>
      _build(AppColors.light, Brightness.light, fontFamily);

  static ThemeData dark({required String fontFamily}) =>
      _build(AppColors.dark, Brightness.dark, fontFamily);

  static ThemeData _build(AppColors c, Brightness brightness, String font) {
    final scheme = ColorScheme(
      brightness: brightness,
      primary: c.primary,
      onPrimary: c.onPrimary,
      primaryContainer: c.primaryContainer,
      onPrimaryContainer: c.primaryDark,
      secondary: c.primaryDark,
      onSecondary: c.onPrimary,
      error: c.danger,
      onError: c.onPrimary,
      errorContainer: c.dangerSoft,
      onErrorContainer: c.dangerText,
      surface: c.surface,
      onSurface: c.textPrimary,
      onSurfaceVariant: c.textMuted,
      outline: c.line,
      outlineVariant: c.line,
    );

    final textTheme = AppTypography.textTheme(font)
        .apply(bodyColor: c.textPrimary, displayColor: c.textPrimary);

    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
    );
    const buttonSize = Size(64, AppSizes.buttonHeight);

    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: color, width: width),
        );

    return ThemeData(
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: font,
      textTheme: textTheme,
      scaffoldBackgroundColor: c.background,
      extensions: [c],
      materialTapTargetSize: MaterialTapTargetSize.padded,
      appBarTheme: AppBarTheme(
        backgroundColor: c.background,
        foregroundColor: c.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: textTheme.titleLarge,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: buttonSize,
          shape: buttonShape,
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: buttonSize,
          shape: buttonShape,
          foregroundColor: c.textPrimary,
          side: BorderSide(color: c.line),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(64, AppSizes.minTapTarget),
          foregroundColor: c.primary,
          textStyle: textTheme.labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        hintStyle: textTheme.bodyLarge?.copyWith(color: c.textMuted),
        border: border(c.line),
        enabledBorder: border(c.line),
        focusedBorder: border(c.primary, 2),
        errorBorder: border(c.danger),
        focusedErrorBorder: border(c.danger, 2),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: AppSizes.bottomNavHeight,
        backgroundColor: c.surface,
        indicatorColor: c.primaryContainer,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: c.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: BorderSide(color: c.line),
        ),
      ),
      dividerTheme: DividerThemeData(color: c.line, thickness: 1, space: 1),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }
}
