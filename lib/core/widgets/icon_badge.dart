import 'package:flutter/material.dart';

import 'package:alvaro_pay/core/theme/app_colors.dart';

// A soft circular icon badge used for quick actions and transaction
// history rows, so the icon treatment stays consistent everywhere.
class IconBadge extends StatelessWidget {
  const IconBadge({super.key, required this.icon, this.size = 44});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(color: Color(0xFFF1E9FB), shape: BoxShape.circle),
      child: Icon(icon, color: AppColors.purplePrimary, size: size * 0.5),
    );
  }
}
