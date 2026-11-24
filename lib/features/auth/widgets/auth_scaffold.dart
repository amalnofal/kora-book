import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/widgets/app_logo.dart';

/// Shared layout for every auth screen: a soft green circle in the
/// background, the logo + [tagline] on top, and a white bottom sheet
/// holding the screen content.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.tagline,
    this.leading,
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final String? tagline;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: context.colors.authBackground,
      body: Stack(
        children: [
          PositionedDirectional(
            top: -180,
            end: -130,
            child: IgnorePointer(
              child: Container(
                width: 340,
                height: 340,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.primaryContainer,
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 480),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                AppSpacing.xl,
                                64,
                                AppSpacing.xl,
                                12,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const AppLogo(),
                                  if (tagline != null) ...[
                                    const SizedBox(height: AppSpacing.md),
                                    Text(
                                      tagline!,
                                      style: text.bodyMedium?.copyWith(
                                        color: colors.textMuted,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  AppSpacing.xl,
                                  AppSpacing.xl,
                                  AppSpacing.xl,
                                  AppSpacing.xxl + bottomInset,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.surface,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(AppRadius.pill),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: colors.textPrimary.withValues(
                                        alpha: 0.06,
                                      ),
                                      blurRadius: 30,
                                      offset: const Offset(0, -6),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (leading != null) ...[
                                      Align(
                                        alignment:
                                            AlignmentDirectional.centerStart,
                                        child: leading!,
                                      ),
                                      const SizedBox(height: AppSpacing.md),
                                    ],

                                    if (title != null)
                                      Text(title!, style: text.headlineSmall),
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
                            ),
                          ],
                        ),
                      ),
                    ),
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
