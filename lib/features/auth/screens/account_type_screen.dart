import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/config/app_config.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/router/routes.dart';
import '../../../core/session/session_repository.dart' show AccountRole;
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../widgets/auth_back_link.dart';
import '../widgets/auth_primary_button.dart';
import '../widgets/auth_scaffold.dart';

class AccountTypeScreen extends StatefulWidget {
  const AccountTypeScreen({super.key});

  @override
  State<AccountTypeScreen> createState() => _AccountTypeScreenState();
}

class _AccountTypeScreenState extends State<AccountTypeScreen> {
  AccountRole? _selected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final selected = _selected;

    return AuthScaffold(
      tagline: l10n.accountTypeTagline,
      leading: AuthBackLink(
        label: l10n.accountTypeBackToSignIn,
        onPressed: () => context.go(Routes.auth),
      ),
      title: l10n.accountTypeTitle,
      subtitle: l10n.accountTypeSubtitle(AppConfig.appName),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AccountTypeOption(
            icon: Icons.sports_soccer,
            title: l10n.accountTypeCustomerTitle,
            description: l10n.accountTypeCustomerDescription,
            badge: l10n.accountTypeCustomerBadge,
            selected: selected == AccountRole.customer,
            onTap: () => setState(() => _selected = AccountRole.customer),
          ),
          const SizedBox(height: AppSpacing.md),
          _AccountTypeOption(
            icon: Icons.home_outlined,
            title: l10n.accountTypeVenueTitle,
            description: l10n.accountTypeVenueDescription,
            badge: l10n.accountTypeVenueBadge,
            selected: selected == AccountRole.venue,
            onTap: () => setState(() => _selected = AccountRole.venue),
          ),
          const SizedBox(height: AppSpacing.xl),
          AuthPrimaryButton(
            label: l10n.continueButton,
            onPressed: selected == null
                ? null
                : () =>
                      context.push('${Routes.register}?role=${selected.name}'),
          ),
        ],
      ),
    );
  }
}

class _AccountTypeOption extends StatelessWidget {
  const _AccountTypeOption({
    required this.icon,
    required this.title,
    required this.description,
    required this.badge,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final String badge;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(AppRadius.lg);

    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? colors.primarySoft : colors.background,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(
                color: selected ? colors.primary : colors.line,
                width: selected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(icon, color: colors.primary, size: 24),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: text.titleSmall),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        description,
                        style: text.bodySmall?.copyWith(
                          color: colors.textMuted,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        badge.toUpperCase(),
                        style: text.labelSmall?.copyWith(
                          color: colors.primaryText,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                _SelectRing(selected: selected),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectRing extends StatelessWidget {
  const _SelectRing({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? colors.primary : colors.lineStrong,
          width: 1.5,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.primary,
                ),
              ),
            )
          : null,
    );
  }
}
