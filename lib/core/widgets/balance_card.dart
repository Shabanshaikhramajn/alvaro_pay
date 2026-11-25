import 'package:flutter/material.dart';

import 'package:alvaro_pay/core/theme/app_colors.dart';

// The purple/gold balance card at the top of the wallet home screen.
// Balance visibility is owned by the parent, since it's just UI state;
// this widget owns two animations of its own: the fade/scale swap
// between the real balance and the dots, and a count-up/down tween
// whenever the underlying balance value itself changes (e.g. right
// after a successful transaction).
class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.label,
    required this.balance,
    required this.currencySymbol,
    required this.isBalanceVisible,
    required this.onToggleVisibility,
    required this.visibilityTooltip,
  });

  final String label;
  final double? balance;
  final String currencySymbol;
  final bool isBalanceVisible;
  final VoidCallback onToggleVisibility;
  final String visibilityTooltip;

  static const TextStyle _amountStyle = TextStyle(
    color: AppColors.gold,
    fontSize: 30,
    fontWeight: FontWeight.w700,
  );

  @override
  Widget build(BuildContext context) {
    final double? currentBalance = balance;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.purpleGradient,
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(scale: animation, child: child),
                  ),
                  child: currentBalance == null
                      ? const Text('--', key: ValueKey<String>('loading'), style: _amountStyle)
                      : (isBalanceVisible
                          ? _AnimatedAmount(
                              key: const ValueKey<String>('visible'),
                              balance: currentBalance,
                              currencySymbol: currencySymbol,
                            )
                          : const Text('••••••', key: ValueKey<String>('hidden'), style: _amountStyle)),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: visibilityTooltip,
            onPressed: onToggleVisibility,
            icon: Icon(
              isBalanceVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded,
              color: AppColors.goldLight,
            ),
          ),
        ],
      ),
    );
  }
}

// Counts up/down from the previously-shown value to the new one. On
// first mount (e.g. right after toggling visibility back on) there is
// no previous value to animate from, so it just shows the figure -
// only a genuine balance change (same widget staying mounted) tweens.
class _AnimatedAmount extends StatelessWidget {
  const _AnimatedAmount({super.key, required this.balance, required this.currencySymbol});

  final double balance;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: balance),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Text(
        '$currencySymbol${value.toStringAsFixed(2)}',
        style: BalanceCard._amountStyle,
      ),
    );
  }
}
