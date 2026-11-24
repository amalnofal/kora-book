import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kora_book/core/router/routes.dart';
import 'package:kora_book/features/auth/cubit/login_cubit/login_cubit.dart';
import 'package:kora_book/features/auth/widgets/auth_primary_button.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/config/app_config.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_text_field.dart';
import '../cubit/auth_failure_message.dart';
import '../data/auth_repository.dart';
import '../widgets/auth_error_banner.dart';
import '../widgets/auth_scaffold.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(getIt<AuthRepository>()),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    context.read<LoginCubit>().submit(
      email: _email.text,
      password: _password.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final state = context.watch<LoginCubit>().state;
    final loading = state is LoginLoading;

    final linkStyle = TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      minimumSize: const Size(0, AppSizes.minTapTarget),
    );
    final linkTextStyle = text.labelMedium?.copyWith(
      color: colors.primaryText,
      fontWeight: FontWeight.w700,
    );

    return AuthScaffold(
      tagline: l10n.authTagline,
      title: l10n.loginTitle,
      subtitle: l10n.loginSubtitle,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              label: l10n.emailLabel,
              hint: l10n.emailHint,
              controller: _email,
              forceLtr: true,
              enabled: !loading,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              validator: (value) => Validators.email(value, l10n),
              onChanged: (_) => context.read<LoginCubit>().clearError(),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: l10n.passwordLabel,
              hint: '••••••••',
              controller: _password,
              isPassword: true,
              enabled: !loading,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              validator: (value) => Validators.passwordRequired(value, l10n),
              onChanged: (_) => context.read<LoginCubit>().clearError(),
              onFieldSubmitted: (_) => _submit(),
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                style: linkStyle,
                // Wired to the forgot-password screen in its own batch.
                onPressed: () {},
                child: Text(l10n.forgotPasswordLink, style: linkTextStyle),
              ),
            ),

            if (state is LoginError) ...[
              AuthErrorBanner(message: state.failure.message(l10n)),
              const SizedBox(height: AppSpacing.lg),
            ],
            AuthPrimaryButton(
              label: l10n.signInButton,
              loading: loading,
              onPressed: _submit,
            ),
            const SizedBox(height: AppSpacing.xl),

            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  l10n.newToApp(AppConfig.appName),
                  style: text.bodyMedium?.copyWith(color: colors.textMuted),
                ),
                TextButton(
                  style: linkStyle,
                  onPressed: () => context.push(Routes.accountType),
                  child: Text(l10n.createAccountLink, style: linkTextStyle),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
