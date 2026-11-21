import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart'
    hide GlobalMaterialLocalizations, GlobalCupertinoLocalizations;
import 'package:material_ui/material_ui.dart';

import 'core/config/app_config.dart';
import 'core/di/service_locator.dart';
import 'core/l10n/l10n.dart';
import 'core/router/app_router.dart';
import 'core/settings/cubit/settings_cubit.dart';
import 'core/theme/app_fonts.dart';
import 'core/theme/app_theme.dart';

class KoraBookApp extends StatelessWidget {
  const KoraBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<SettingsCubit>(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settings) {
          final font = AppFonts.forLanguage(settings.locale.languageCode);
          return MaterialApp.router(
            title: AppConfig.appName,
            locale: settings.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: AppTheme.light(fontFamily: font),
            darkTheme: AppTheme.dark(fontFamily: font),
            themeMode: settings.themeMode,
            routerConfig: getIt<AppRouter>().router,
          );
        },
      ),
    );
  }
}
