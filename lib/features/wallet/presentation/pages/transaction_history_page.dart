import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:alvaro_pay/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:alvaro_pay/features/wallet/presentation/bloc/wallet_event.dart';
import 'package:alvaro_pay/features/wallet/presentation/bloc/wallet_state.dart';
import 'package:alvaro_pay/features/wallet/presentation/widgets/transaction_tile.dart';
import 'package:alvaro_pay/l10n/generated/app_localizations.dart';

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.transactionHistoryTitle)),
      body: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, state) {
          final String currencySymbol = state.wallet?.currencySymbol ?? '\$';

          Future<void> refresh() async {
            context.read<WalletBloc>().add(const WalletLoadRequested());
          }

          if (state.transactions.isEmpty) {
            return RefreshIndicator(
              onRefresh: refresh,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: <Widget>[
                  const SizedBox(height: 60),
                  const Icon(Icons.receipt_long_outlined, size: 64, color: Colors.black26),
                  const SizedBox(height: 16),
                  Text(
                    l10n.historyEmptyTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.historyEmptySubtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: refresh,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.transactions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) => TransactionTile(
                transaction: state.transactions[index],
                currencySymbol: currencySymbol,
              ),
            ),
          );
        },
      ),
    );
  }
}
