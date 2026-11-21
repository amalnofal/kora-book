import 'package:material_ui/material_ui.dart';

import 'core/theme/app_fonts.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/adaptive_content.dart';

class KoraBookApp extends StatelessWidget {
  const KoraBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Temporary: the font/theme mode become locale/user driven with l10n.
    return MaterialApp(
      title: 'Kora Book',
      theme: AppTheme.light(fontFamily: AppFonts.inter),
      darkTheme: AppTheme.dark(fontFamily: AppFonts.inter),
      themeMode: ThemeMode.light,
      home: const _ThemePreview(),
    );
  }
}

// Temporary screen to eyeball the theme. Removed in the router step.
class _ThemePreview extends StatelessWidget {
  const _ThemePreview();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Kora Book')),
      body: SafeArea(
        child: AdaptiveContent(
          child: ListView(
            children: [
              Text('Headline', style: text.headlineSmall),
              const SizedBox(height: 8),
              Text(
                'Body text 14 / 16 / Cairo: حجز ملعب',
                style: text.bodyMedium,
              ),
              const SizedBox(height: 16),
              const TextField(decoration: InputDecoration(hintText: 'Input')),
              const SizedBox(height: 16),
              FilledButton(onPressed: () {}, child: const Text('Button')),
              const SizedBox(height: 8),
              OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
            ],
          ),
        ),
      ),
    );
  }
}
