part of 'settings_cubit.dart';

class SettingsState {
  const SettingsState({required this.locale, required this.themeMode});

  final Locale locale;
  final ThemeMode themeMode;

  SettingsState copyWith({Locale? locale, ThemeMode? themeMode}) =>
      SettingsState(
        locale: locale ?? this.locale,
        themeMode: themeMode ?? this.themeMode,
      );
}
