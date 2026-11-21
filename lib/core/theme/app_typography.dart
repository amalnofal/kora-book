import 'package:material_ui/material_ui.dart';

class AppTypography {
  AppTypography._();

  static TextTheme textTheme(String fontFamily) {
    TextStyle s(double size, FontWeight weight, double height) => TextStyle(
      fontFamily: fontFamily,
      fontSize: size,
      fontWeight: weight,
      height: height,
    );

    return TextTheme(
      displayMedium: s(32, FontWeight.w700, 1.25),
      headlineMedium: s(28, FontWeight.w700, 1.3),
      headlineSmall: s(24, FontWeight.w700, 1.3),
      titleLarge: s(20, FontWeight.w700, 1.4),
      titleMedium: s(16, FontWeight.w600, 1.5),
      titleSmall: s(14, FontWeight.w600, 1.5),
      bodyLarge: s(16, FontWeight.w400, 1.5),
      bodyMedium: s(14, FontWeight.w400, 1.5),
      bodySmall: s(12, FontWeight.w400, 1.5),
      labelLarge: s(16, FontWeight.w600, 1.4),
      labelMedium: s(14, FontWeight.w500, 1.4),
      labelSmall: s(12, FontWeight.w500, 1.4),
    );
  }
}
