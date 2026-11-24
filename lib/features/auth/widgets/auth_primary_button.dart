import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';

/// Main green button of the auth screens: label + chevron, soft glow,
/// and a spinner while [loading]. Pass a null [onPressed] to disable it.
class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // While loading the button keeps its look but ignores taps.
    final VoidCallback? effective = loading ? () {} : onPressed;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: effective == null
            ? null
            : [
                BoxShadow(
                  color: colors.primary.withValues(alpha: 0.22),
                  blurRadius: 18,
                  offset: const Offset(0, 7),
                ),
              ],
      ),
      child: FilledButton(
        onPressed: effective,
        style: FilledButton.styleFrom(
          disabledForegroundColor: colors.textSubtle,
        ),
        child: loading
            ? SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: colors.onPrimary,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label),
                  const SizedBox(width: AppSpacing.sm),
                  const Icon(Icons.chevron_right),
                ],
              ),
      ),
    );
  }
}
