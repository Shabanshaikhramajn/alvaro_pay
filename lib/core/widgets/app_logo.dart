import 'package:flutter/material.dart';

import 'package:alvaro_pay/core/theme/app_colors.dart';

// The circular brand mark (gold wallet icon on a purple gradient disc)
// shown on the auth screen - kept as one widget so the mark stays
// consistent anywhere else it's reused.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 72});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.purpleGradient,
        ),
      ),
      child: Icon(Icons.account_balance_wallet_rounded, color: AppColors.gold, size: size * 0.5),
    );
  }
}
