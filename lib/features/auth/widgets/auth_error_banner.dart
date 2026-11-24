import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';

/// Inline error box shown inside auth forms.
class AuthErrorBanner extends StatelessWidget {
  const AuthErrorBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.dangerSoft,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: colors.dangerBorder),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: colors.danger, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: colors.dangerText),
            ),
          ),
        ],
      ),
    );
  }
}
