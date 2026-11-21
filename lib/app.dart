import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kora_book/core/config/app_config.dart';
import 'package:kora_book/core/settings/cubit/settings_cubit.dart';
import 'package:flutter_localizations/flutter_localizations.dart'
    hide GlobalMaterialLocalizations, GlobalCupertinoLocalizations;
import 'package:material_ui/material_ui.dart';

import 'core/di/service_locator.dart';
import 'core/l10n/l10n.dart';
import 'core/theme/app_fonts.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/adaptive_content.dart';

class KoraBookApp extends StatelessWidget {
  const KoraBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<SettingsCubit>(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settings) {
          final font = AppFonts.forLanguage(settings.locale.languageCode);
          return MaterialApp(
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
            home: const _ThemePreview(),
          );
        },
      ),
    );
  }
}

// Temporary screen. Removed in the router step.
class _ThemePreview extends StatelessWidget {
  const _ThemePreview();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final settings = context.read<SettingsCubit>();
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(AppConfig.appName)),
      body: SafeArea(
        child: AdaptiveContent(
          child: ListView(
            children: [
              Text(AppConfig.appName, style: text.headlineSmall),
              const SizedBox(height: 8),
              Text('حجز ملعب - Pitch booking 300', style: text.bodyMedium),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => settings.setLocale(Locale(isAr ? 'en' : 'ar')),
                child: Text(context.l10n.language),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => settings.setThemeMode(
                  isDark ? ThemeMode.light : ThemeMode.dark,
                ),
                child: Text(context.l10n.theme),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
