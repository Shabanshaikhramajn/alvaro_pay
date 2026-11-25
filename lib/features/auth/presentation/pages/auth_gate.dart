import 'package:flutter/material.dart';

import 'package:alvaro_pay/core/di/injection_container.dart';
import 'package:alvaro_pay/core/theme/app_colors.dart';
import 'package:alvaro_pay/core/utils/page_transitions.dart';
import 'package:alvaro_pay/core/widgets/app_logo.dart';
import 'package:alvaro_pay/features/auth/domain/usecases/get_cached_session_usecase.dart';
import 'package:alvaro_pay/features/auth/presentation/pages/auth_page.dart';
import 'package:alvaro_pay/features/wallet/presentation/pages/wallet_home_page.dart';

// Checked once at launch: if a previous login/sign-up saved a session
// (see AuthSessionLocalDataSource), skip straight to the wallet instead
// of always showing the login screen first.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkSession());
  }

  Future<void> _checkSession() async {
    final user = await sl<GetCachedSessionUseCase>().call();
    if (!mounted) {
      return;
    }
    Navigator.of(context).pushReplacement(
      buildSlideUpRoute<void>(user != null ? const WalletHomePage() : const AuthPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.purplePrimary,
      body: Center(child: AppLogo(size: 88)),
    );
  }
}
