import 'package:flutter/material.dart';

// Alvaro Pay's brand palette: deep purple as the primary brand color,
// gold as the accent used for balances, highlights and primary actions.
class AppColors {
  const AppColors._();

  static const Color purplePrimary = Color(0xFF4A148C);
  static const Color purpleDark = Color(0xFF2E0B59);
  static const Color purpleLight = Color(0xFF7B3FB5);

  static const Color gold = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFF3D98B);
  static const Color goldDark = Color(0xFFA67C1E);

  static const Color background = Color(0xFFF7F4FB);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF221433);
  static const Color textSecondary = Color(0xFF6E6481);

  static const Color success = Color(0xFF2E7D32);
  static const Color error = Color(0xFFC62828);

  static const List<Color> purpleGradient = <Color>[purpleDark, purplePrimary];
}
