import 'package:flutter/material.dart';

import 'package:alvaro_pay/core/theme/app_colors.dart';

// A small hand-built "illustration" of two overlapping payment cards,
// shown on the auth screen in place of a photo. There's no bitmap asset
// pipeline in this demo, so this is composed entirely from gradients
// and shapes instead of an image file.
class WalletCardIllustration extends StatelessWidget {
  const WalletCardIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            right: 12,
            child: Transform.rotate(
              angle: 0.12,
              child: _card(colors: <Color>[AppColors.goldDark, AppColors.gold]),
            ),
          ),
          Positioned(
            left: 12,
            child: Transform.rotate(
              angle: -0.08,
              child: _card(colors: AppColors.purpleGradient),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required List<Color> colors}) {
    return Container(
      width: 210,
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Color(0x332E0B59), blurRadius: 16, offset: Offset(0, 10)),
        ],
      ),
      child: const Align(
        alignment: Alignment.topLeft,
        child: Icon(Icons.contactless_rounded, color: Colors.white70, size: 26),
      ),
    );
  }
}
