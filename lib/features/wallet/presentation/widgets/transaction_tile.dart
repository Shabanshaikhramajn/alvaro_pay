import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:alvaro_pay/core/theme/app_colors.dart';
import 'package:alvaro_pay/core/widgets/icon_badge.dart';
import 'package:alvaro_pay/features/wallet/domain/entities/wallet_transaction.dart';
import 'package:alvaro_pay/l10n/generated/app_localizations.dart';

// One row in the "Recent activity" list and the full history page -
// same widget, same look, in both places.
class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction, required this.currencySymbol});

  final WalletTransaction transaction;
  final String currencySymbol;

  IconData get _icon {
    switch (transaction.type) {
      case TransactionType.sendMoney:
        return Icons.send_rounded;
      case TransactionType.buyAirtime:
        return Icons.sim_card_rounded;
      case TransactionType.payBill:
        return Icons.receipt_long_rounded;
    }
  }

  String _title(AppLocalizations l10n) {
    switch (transaction.type) {
      case TransactionType.sendMoney:
        return l10n.transactionSentToLabel(transaction.counterpart);
      case TransactionType.buyAirtime:
        return l10n.transactionAirtimeLabel(transaction.counterpart);
      case TransactionType.payBill:
        return l10n.transactionBillLabel(transaction.counterpart);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String time = DateFormat('MMM d, h:mm a').format(transaction.timestamp);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Color(0x114A148C), blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: <Widget>[
          IconBadge(icon: _icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _title(l10n),
                  style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(time, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Text(
            '-$currencySymbol${transaction.amount.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.error),
          ),
        ],
      ),
    );
  }
}
