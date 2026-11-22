import 'package:material_ui/material_ui.dart';

import '../config/app_config.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';

/// Brand mark (exported from Figma) + app name.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;

    final words = AppConfig.appName.split(' ');
    final lead = words.length > 1
        ? '${words.sublist(0, words.length - 1).join(' ')} '
        : '';
    final last = words.last;

    final box = compact ? 40.0 : 48.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo_mark.png',
          width: box,
          height: box,
          filterQuality: FilterQuality.medium,
        ),
        const SizedBox(width: AppSpacing.md),
        Text.rich(
          TextSpan(
            text: lead,
            children: [
              TextSpan(
                text: last,
                style: TextStyle(color: colors.primary),
              ),
            ],
          ),
          style: (compact ? text.titleLarge : text.headlineSmall)?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
