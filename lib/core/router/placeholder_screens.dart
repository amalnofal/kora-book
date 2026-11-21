import 'package:material_ui/material_ui.dart';

import '../l10n/l10n.dart';
import '../settings/cubit/settings_cubit.dart';
import '../di/service_locator.dart';

// Temporary. Replaced by real screens in Phases 2-4.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final settings = getIt<SettingsCubit>();
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      appBar: AppBar(title: Text(label)),
      body: Center(
        child: FilledButton(
          onPressed: () => settings.setLocale(Locale(isAr ? 'en' : 'ar')),
          child: Text(context.l10n.language),
        ),
      ),
    );
  }
}
