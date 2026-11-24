import 'package:material_ui/material_ui.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primary,
    required this.primaryDark,
    required this.primarySoft,
    required this.primaryContainer,
    required this.primaryBorder,
    required this.primaryText,
    required this.onPrimary,
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textMuted,
    required this.line,
    required this.authBackground,
    required this.textSubtle,
    required this.lineStrong,
    required this.warning,
    required this.warningSoft,
    required this.warningBorder,
    required this.warningText,
    required this.danger,
    required this.dangerSoft,
    required this.dangerBorder,
    required this.dangerText,
  });

  final Color primary;
  final Color primaryDark;
  final Color primarySoft;
  final Color primaryContainer;
  final Color primaryBorder;
  final Color primaryText;
  final Color onPrimary;
  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textMuted;
  final Color line;
  final Color authBackground;
  final Color textSubtle;
  final Color lineStrong;
  final Color warning;
  final Color warningSoft;
  final Color warningBorder;
  final Color warningText;
  final Color danger;
  final Color dangerSoft;
  final Color dangerBorder;
  final Color dangerText;

  static const light = AppColors(
    primary: Color(0xFF16A34A),
    primaryDark: Color(0xFF166534),
    primarySoft: Color(0xFFF0FDF4),
    primaryContainer: Color(0xFFDCFCE7),
    primaryBorder: Color(0xFFBBF7D0),
    primaryText: Color(0xFF15803D),
    onPrimary: Color(0xFFFFFFFF),
    background: Color(0xFFF8FAFC),
    surface: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF0F172A),
    textMuted: Color(0xFF64748B),
    line: Color(0xFFE2E8F0),
    authBackground: Color(0xFFF4F8F5),
    textSubtle: Color(0xFF94A3B8),
    lineStrong: Color(0xFFCBD5E1),
    warning: Color(0xFFF59E0B),
    warningSoft: Color(0xFFFFFBEB),
    warningBorder: Color(0xFFFDE68A),
    warningText: Color(0xFF92400E),
    danger: Color(0xFFDC2626),
    dangerSoft: Color(0xFFFEE2E2),
    dangerBorder: Color(0xFFFECACA),
    dangerText: Color(0xFF991B1B),
  );

  static const dark = AppColors(
    primary: Color(0xFF16A34A),
    primaryDark: Color(0xFF4ADE80),
    primarySoft: Color(0xFF0F2A1C),
    primaryContainer: Color(0xFF14532D),
    primaryBorder: Color(0xFF166534),
    primaryText: Color(0xFF4ADE80),
    onPrimary: Color(0xFFFFFFFF),
    background: Color(0xFF0B1210),
    surface: Color(0xFF151F1B),
    textPrimary: Color(0xFFF1F5F9),
    textMuted: Color(0xFF94A3B8),
    line: Color(0xFF2A3832),
    authBackground: Color(0xFF0B1210),
    textSubtle: Color(0xFF64748B),
    lineStrong: Color(0xFF3B4A43),
    warning: Color(0xFFF59E0B),
    warningSoft: Color(0xFF2A2008),
    warningBorder: Color(0xFF78350F),
    warningText: Color(0xFFFCD34D),
    danger: Color(0xFFEF4444),
    dangerSoft: Color(0xFF2A1010),
    dangerBorder: Color(0xFF7F1D1D),
    dangerText: Color(0xFFFCA5A5),
  );

  @override
  AppColors copyWith({
    Color? primary,
    Color? primaryDark,
    Color? primarySoft,
    Color? primaryContainer,
    Color? primaryBorder,
    Color? primaryText,
    Color? onPrimary,
    Color? background,
    Color? surface,
    Color? textPrimary,
    Color? textMuted,
    Color? line,
    Color? authBackground,
    Color? textSubtle,
    Color? lineStrong,
    Color? warning,
    Color? warningSoft,
    Color? warningBorder,
    Color? warningText,
    Color? danger,
    Color? dangerSoft,
    Color? dangerBorder,
    Color? dangerText,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      primaryDark: primaryDark ?? this.primaryDark,
      primarySoft: primarySoft ?? this.primarySoft,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      primaryBorder: primaryBorder ?? this.primaryBorder,
      primaryText: primaryText ?? this.primaryText,
      onPrimary: onPrimary ?? this.onPrimary,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      textPrimary: textPrimary ?? this.textPrimary,
      textMuted: textMuted ?? this.textMuted,
      line: line ?? this.line,
      authBackground: authBackground ?? this.authBackground,
      textSubtle: textSubtle ?? this.textSubtle,
      lineStrong: lineStrong ?? this.lineStrong,
      warning: warning ?? this.warning,
      warningSoft: warningSoft ?? this.warningSoft,
      warningBorder: warningBorder ?? this.warningBorder,
      warningText: warningText ?? this.warningText,
      danger: danger ?? this.danger,
      dangerSoft: dangerSoft ?? this.dangerSoft,
      dangerBorder: dangerBorder ?? this.dangerBorder,
      dangerText: dangerText ?? this.dangerText,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      primary: l(primary, other.primary),
      primaryDark: l(primaryDark, other.primaryDark),
      primarySoft: l(primarySoft, other.primarySoft),
      primaryContainer: l(primaryContainer, other.primaryContainer),
      primaryBorder: l(primaryBorder, other.primaryBorder),
      primaryText: l(primaryText, other.primaryText),
      onPrimary: l(onPrimary, other.onPrimary),
      background: l(background, other.background),
      surface: l(surface, other.surface),
      textPrimary: l(textPrimary, other.textPrimary),
      textMuted: l(textMuted, other.textMuted),
      line: l(line, other.line),
      authBackground: l(authBackground, other.authBackground),
      textSubtle: l(textSubtle, other.textSubtle),
      lineStrong: l(lineStrong, other.lineStrong),
      warning: l(warning, other.warning),
      warningSoft: l(warningSoft, other.warningSoft),
      warningBorder: l(warningBorder, other.warningBorder),
      warningText: l(warningText, other.warningText),
      danger: l(danger, other.danger),
      dangerSoft: l(dangerSoft, other.dangerSoft),
      dangerBorder: l(dangerBorder, other.dangerBorder),
      dangerText: l(dangerText, other.dangerText),
    );
  }
}

extension AppColorsContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
