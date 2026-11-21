import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._prefs)
    : super(
        SettingsState(
          locale: Locale(_prefs.getString(_localeKey) ?? _defaultLocale()),
          themeMode: ThemeMode.values.firstWhere(
            (m) => m.name == _prefs.getString(_themeKey),
            orElse: () => ThemeMode.light,
          ),
        ),
      );

  final SharedPreferences _prefs;

  static const _localeKey = 'locale';
  static const _themeKey = 'theme_mode';

  // First launch: Arabic if the device is Arabic, otherwise English.
  static String _defaultLocale() =>
      PlatformDispatcher.instance.locale.languageCode == 'ar' ? 'ar' : 'en';

  Future<void> setLocale(Locale locale) async {
    emit(state.copyWith(locale: locale));
    await _prefs.setString(_localeKey, locale.languageCode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    emit(state.copyWith(themeMode: mode));
    await _prefs.setString(_themeKey, mode.name);
  }
}
