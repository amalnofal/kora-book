import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/widgets/app_logo.dart';

/// Shared layout for every auth screen: soft green glow background,
/// logo, and a white card holding the screen content.
/// Pass [onBack] to show a back button (register, OTP, ...).
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.onBack,
    this.tagline,
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final VoidCallback? onBack;
  final String? tagline;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return Scaffold(
      body: Stack(
        children: [
          PositionedDirectional(
            top: -140,
            start: 0,
            end: 0,
            child: IgnorePointer(
              child: Container(
                height: 380,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topCenter,
                    radius: 0.9,
                    colors: [
                      colors.primary.withValues(alpha: 0.16),
                      colors.primary.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.lg,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (onBack != null)
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: IconButton(
                            onPressed: onBack,
                            icon: const Icon(Icons.arrow_back),
                          ),
                        )
                      else
                        const SizedBox(height: AppSpacing.xl),
                      const Center(child: AppLogo()),
                      if (tagline != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          tagline!,
                          textAlign: TextAlign.center,
                          style: text.bodyMedium?.copyWith(
                            color: colors.textMuted,
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.xxl),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                          border: Border.all(
                            color: theme.colorScheme.outlineVariant,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (title != null)
                              Text(
                                title!,
                                style: text.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            if (subtitle != null) ...[
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                subtitle!,
                                style: text.bodyMedium?.copyWith(
                                  color: colors.textMuted,
                                ),
                              ),
                            ],
                            if (title != null || subtitle != null)
                              const SizedBox(height: AppSpacing.xl),
                            child,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
