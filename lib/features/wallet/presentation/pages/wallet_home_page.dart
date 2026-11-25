import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:alvaro_pay/core/di/injection_container.dart';
import 'package:alvaro_pay/core/theme/app_colors.dart';
import 'package:alvaro_pay/core/utils/page_transitions.dart';
import 'package:alvaro_pay/core/widgets/balance_card.dart';
import 'package:alvaro_pay/core/widgets/fade_slide_in.dart';
import 'package:alvaro_pay/core/widgets/wallet_action_button.dart';
import 'package:alvaro_pay/features/auth/domain/usecases/clear_session_usecase.dart';
import 'package:alvaro_pay/features/auth/presentation/pages/auth_page.dart';
import 'package:alvaro_pay/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:alvaro_pay/features/wallet/presentation/bloc/wallet_event.dart';
import 'package:alvaro_pay/features/wallet/presentation/bloc/wallet_state.dart';
import 'package:alvaro_pay/features/wallet/presentation/pages/buy_airtime_page.dart';
import 'package:alvaro_pay/features/wallet/presentation/pages/pay_bill_page.dart';
import 'package:alvaro_pay/features/wallet/presentation/pages/send_money_page.dart';
import 'package:alvaro_pay/features/wallet/presentation/pages/transaction_history_page.dart';
import 'package:alvaro_pay/features/wallet/presentation/widgets/transaction_tile.dart';
import 'package:alvaro_pay/l10n/generated/app_localizations.dart';

class WalletHomePage extends StatelessWidget {
  const WalletHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WalletBloc>(
      create: (_) => sl<WalletBloc>()..add(const WalletLoadRequested()),
      child: const _WalletHomeView(),
    );
  }
}

class _WalletHomeView extends StatelessWidget {
  const _WalletHomeView();

  // Sub-action pages share this screen's WalletBloc instance (passed
  // down via .value), so a successful send/buy/pay updates the balance
  // here immediately, without any extra plumbing to refresh on return.
  void _openPage(BuildContext context, Widget page) {
    final WalletBloc bloc = context.read<WalletBloc>();
    Navigator.of(context).push(
      buildSlideUpRoute<void>(
        BlocProvider<WalletBloc>.value(value: bloc, child: page),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    await sl<ClearSessionUseCase>().call();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      buildSlideUpRoute<void>(const AuthPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.walletHomeTitle),
        actions: <Widget>[
          IconButton(
            tooltip: l10n.logoutTooltip,
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, state) {
          final wallet = state.wallet;
          final String currencySymbol = wallet?.currencySymbol ?? '';
          final recentTransactions = state.transactions.take(3).toList();

          return RefreshIndicator(
            onRefresh: () async {
              context.read<WalletBloc>().add(const WalletLoadRequested());
            },
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: <Widget>[
                if (state.loadStatus == WalletLoadStatus.loading && wallet == null)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else
                  FadeSlideIn(
                    child: BalanceCard(
                      label: l10n.availableBalanceLabel,
                      balance: wallet?.balance,
                      currencySymbol: currencySymbol,
                      isBalanceVisible: state.isBalanceVisible,
                      visibilityTooltip: state.isBalanceVisible
                          ? l10n.hideBalanceTooltip
                          : l10n.showBalanceTooltip,
                      onToggleVisibility: () =>
                          context.read<WalletBloc>().add(const WalletBalanceVisibilityToggled()),
                    ),
                  ),
                const SizedBox(height: 28),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 80),
                  child: Text(l10n.quickActionsTitle, style: Theme.of(context).textTheme.titleLarge),
                ),
                const SizedBox(height: 14),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 120),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: WalletActionButton(
                          icon: Icons.send_rounded,
                          label: l10n.sendMoneyAction,
                          onTap: () => _openPage(context, const SendMoneyPage()),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: WalletActionButton(
                          icon: Icons.sim_card_rounded,
                          label: l10n.buyAirtimeAction,
                          onTap: () => _openPage(context, const BuyAirtimePage()),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: WalletActionButton(
                          icon: Icons.receipt_long_rounded,
                          label: l10n.payBillsAction,
                          onTap: () => _openPage(context, const PayBillPage()),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 160),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(l10n.recentActivityTitle, style: Theme.of(context).textTheme.titleLarge),
                      TextButton(
                        onPressed: () => _openPage(context, const TransactionHistoryPage()),
                        child: Text(l10n.seeAllAction),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                if (recentTransactions.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      l10n.historyEmptySubtitle,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  )
                else
                  Column(
                    children: <Widget>[
                      for (final (index, transaction) in recentTransactions.indexed)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: FadeSlideIn(
                            // Keyed by transaction id: a brand new entry (freshly
                            // inserted at the top) mounts fresh and animates in,
                            // while existing ones keep their already-settled state.
                            key: ValueKey<String>(transaction.id),
                            delay: Duration(milliseconds: 180 + index * 50),
                            child: TransactionTile(
                              transaction: transaction,
                              currencySymbol: currencySymbol,
                            ),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
