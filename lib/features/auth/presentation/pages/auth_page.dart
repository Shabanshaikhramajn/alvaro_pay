import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:alvaro_pay/core/di/injection_container.dart';
import 'package:alvaro_pay/core/utils/page_transitions.dart';
import 'package:alvaro_pay/core/utils/validators.dart';
import 'package:alvaro_pay/core/widgets/app_logo.dart';
import 'package:alvaro_pay/core/widgets/app_primary_button.dart';
import 'package:alvaro_pay/core/widgets/app_text_field.dart';
import 'package:alvaro_pay/core/widgets/fade_slide_in.dart';
import 'package:alvaro_pay/core/widgets/wallet_card_illustration.dart';
import 'package:alvaro_pay/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:alvaro_pay/features/auth/presentation/bloc/auth_event.dart';
import 'package:alvaro_pay/features/auth/presentation/bloc/auth_state.dart';
import 'package:alvaro_pay/features/wallet/presentation/pages/wallet_home_page.dart';
import 'package:alvaro_pay/l10n/generated/app_localizations.dart';

// The single login/sign-up screen. Which form is shown comes entirely
// from AuthBloc's state (mode), not local widget state, so switching
// modes also resets any in-flight submit/error cleanly.
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => sl<AuthBloc>(),
      child: const _AuthView(),
    );
  }
}

class _AuthView extends StatefulWidget {
  const _AuthView();

  @override
  State<_AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<_AuthView> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _fullNameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  static const Duration _fieldAnimDuration = Duration(milliseconds: 220);

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context, AuthState state) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    setState(() {
      _fullNameError = (!state.isLogin && _fullNameController.text.trim().isEmpty)
          ? l10n.fieldRequiredError
          : null;
      _emailError = _emailController.text.trim().isEmpty
          ? l10n.fieldRequiredError
          : (!Validators.isValidEmail(_emailController.text) ? l10n.invalidEmailError : null);
      _passwordError = _passwordController.text.isEmpty
          ? l10n.fieldRequiredError
          : (_passwordController.text.length < 6 ? l10n.passwordTooShortError : null);
      _confirmPasswordError =
          (!state.isLogin && _confirmPasswordController.text != _passwordController.text)
          ? l10n.passwordMismatchError
          : null;
    });

    final bool hasError = _emailError != null ||
        _passwordError != null ||
        _fullNameError != null ||
        _confirmPasswordError != null;
    if (hasError) {
      return;
    }

    final AuthBloc bloc = context.read<AuthBloc>();
    if (state.isLogin) {
      bloc.add(
        AuthLoginSubmitted(email: _emailController.text.trim(), password: _passwordController.text),
      );
    } else {
      bloc.add(
        AuthSignUpSubmitted(
          fullName: _fullNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  // Grows/shrinks and fades the sign-up-only fields in and out as the
  // mode is toggled, instead of them just snapping in and out of the
  // layout. `padding` reserves the same gap the field would occupy
  // when visible (above or below it), so the surrounding spacing stays
  // identical to a plain conditional field once it's shown.
  Widget _animatedField({
    required bool visible,
    required Widget field,
    required EdgeInsetsGeometry padding,
  }) {
    return AnimatedSize(
      duration: _fieldAnimDuration,
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: AnimatedOpacity(
        duration: _fieldAnimDuration,
        opacity: visible ? 1 : 0,
        child: visible
            ? Padding(padding: padding, child: field)
            : const SizedBox(width: double.infinity),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.failure && state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
            }
            if (state.status == AuthStatus.success) {
              final String message = state.mode == AuthFormMode.login
                  ? l10n.loginSuccessMessage
                  : l10n.signUpSuccessMessage;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
              Navigator.of(context).pushReplacement(
                buildSlideUpRoute<void>(const WalletHomePage()),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  FadeSlideIn(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const WalletCardIllustration(),
                        const SizedBox(height: 20),
                        const Center(child: AppLogo()),
                        const SizedBox(height: 16),
                        Text(
                          l10n.appName,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 260),
                    transitionBuilder: (child, animation) =>
                        FadeTransition(opacity: animation, child: child),
                    child: Column(
                      key: ValueKey<AuthFormMode>(state.mode),
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          state.isLogin ? l10n.loginWelcomeTitle : l10n.signUpWelcomeTitle,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          state.isLogin ? l10n.loginWelcomeSubtitle : l10n.signUpWelcomeSubtitle,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _animatedField(
                    visible: !state.isLogin,
                    padding: const EdgeInsets.only(bottom: 16),
                    field: AppTextField(
                      label: l10n.fullNameLabel,
                      controller: _fullNameController,
                      errorText: _fullNameError,
                      prefixIcon: Icons.person_outline_rounded,
                    ),
                  ),
                  AppTextField(
                    label: l10n.emailLabel,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    errorText: _emailError,
                    prefixIcon: Icons.alternate_email_rounded,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    label: l10n.passwordLabel,
                    controller: _passwordController,
                    obscureText: true,
                    errorText: _passwordError,
                    prefixIcon: Icons.lock_outline_rounded,
                  ),
                  _animatedField(
                    visible: !state.isLogin,
                    padding: const EdgeInsets.only(top: 16),
                    field: AppTextField(
                      label: l10n.confirmPasswordLabel,
                      controller: _confirmPasswordController,
                      obscureText: true,
                      errorText: _confirmPasswordError,
                      prefixIcon: Icons.lock_outline_rounded,
                    ),
                  ),
                  const SizedBox(height: 28),
                  AppPrimaryButton(
                    label: state.isLogin ? l10n.loginButton : l10n.signUpButton,
                    isLoading: state.isSubmitting,
                    onPressed: () => _submit(context, state),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () => context.read<AuthBloc>().add(const AuthModeToggled()),
                      child: Text(
                        state.isLogin
                            ? '${l10n.switchToSignUpPrompt} ${l10n.switchToSignUpAction}'
                            : '${l10n.switchToLoginPrompt} ${l10n.switchToLoginAction}',
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
