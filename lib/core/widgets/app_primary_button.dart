import 'package:flutter/material.dart';

import 'package:alvaro_pay/core/theme/app_colors.dart';

// Primary call-to-action button used across the app (login, sign up,
// send money, buy airtime, pay bills) - one place to control the gold
// button look and its loading state.
class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2.4, color: AppColors.purpleDark),
              )
            : Text(label),
      ),
    );
  }
}
