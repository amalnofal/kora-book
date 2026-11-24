import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';

/// "← Back" link shown at the top of the auth card.
class AuthBackLink extends StatelessWidget {
  const AuthBackLink({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.arrow_back, size: 18),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: colors.textMuted,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        minimumSize: const Size(0, AppSizes.minTapTarget),
        textStyle: Theme.of(context).textTheme.labelMedium
            ?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
