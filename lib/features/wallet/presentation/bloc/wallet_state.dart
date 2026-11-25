import 'package:equatable/equatable.dart';

import 'package:alvaro_pay/features/wallet/domain/entities/wallet.dart';
import 'package:alvaro_pay/features/wallet/domain/entities/wallet_transaction.dart';

enum WalletLoadStatus { initial, loading, loaded, loadFailure }

enum WalletActionStatus { idle, inProgress, success, failure }

class WalletState extends Equatable {
  const WalletState({
    this.loadStatus = WalletLoadStatus.initial,
    this.wallet,
    this.transactions = const <WalletTransaction>[],
    this.isBalanceVisible = true,
    this.actionStatus = WalletActionStatus.idle,
    this.actionMessage,
  });

  final WalletLoadStatus loadStatus;
  final Wallet? wallet;
  final List<WalletTransaction> transactions;
  final bool isBalanceVisible;
  final WalletActionStatus actionStatus;
  final String? actionMessage;

  bool get isActionInProgress => actionStatus == WalletActionStatus.inProgress;

  WalletState copyWith({
    WalletLoadStatus? loadStatus,
    Wallet? wallet,
    List<WalletTransaction>? transactions,
    bool? isBalanceVisible,
    WalletActionStatus? actionStatus,
    String? actionMessage,
    bool clearActionMessage = false,
  }) {
    return WalletState(
      loadStatus: loadStatus ?? this.loadStatus,
      wallet: wallet ?? this.wallet,
      transactions: transactions ?? this.transactions,
      isBalanceVisible: isBalanceVisible ?? this.isBalanceVisible,
      actionStatus: actionStatus ?? this.actionStatus,
      actionMessage: clearActionMessage ? null : (actionMessage ?? this.actionMessage),
    );
  }

  @override
  List<Object?> get props => <Object?>[
    loadStatus,
    wallet,
    transactions,
    isBalanceVisible,
    actionStatus,
    actionMessage,
  ];
}
