class AppFonts {
  AppFonts._();
  static const cairo = 'Cairo';
  static const inter = 'Inter';

  static String forLanguage(String languageCode) =>
      languageCode == 'ar' ? cairo : inter;
}
