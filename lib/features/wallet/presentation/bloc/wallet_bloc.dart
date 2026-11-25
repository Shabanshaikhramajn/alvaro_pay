import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:alvaro_pay/core/usecases/usecase.dart';
import 'package:alvaro_pay/features/wallet/domain/entities/wallet.dart';
import 'package:alvaro_pay/features/wallet/domain/usecases/buy_airtime_usecase.dart';
import 'package:alvaro_pay/features/wallet/domain/usecases/get_transaction_history_usecase.dart';
import 'package:alvaro_pay/features/wallet/domain/usecases/get_wallet_usecase.dart';
import 'package:alvaro_pay/features/wallet/domain/usecases/pay_bill_usecase.dart';
import 'package:alvaro_pay/features/wallet/domain/usecases/send_money_usecase.dart';
import 'package:alvaro_pay/features/wallet/presentation/bloc/wallet_event.dart';
import 'package:alvaro_pay/features/wallet/presentation/bloc/wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc({
    required GetWalletUseCase getWallet,
    required GetTransactionHistoryUseCase getTransactionHistory,
    required SendMoneyUseCase sendMoney,
    required BuyAirtimeUseCase buyAirtime,
    required PayBillUseCase payBill,
  }) : _getWallet = getWallet,
       _getTransactionHistory = getTransactionHistory,
       _sendMoney = sendMoney,
       _buyAirtime = buyAirtime,
       _payBill = payBill,
       super(const WalletState()) {
    on<WalletLoadRequested>(_onLoadRequested);
    on<WalletBalanceVisibilityToggled>(_onVisibilityToggled);
    on<WalletSendMoneyRequested>(_onSendMoneyRequested);
    on<WalletBuyAirtimeRequested>(_onBuyAirtimeRequested);
    on<WalletPayBillRequested>(_onPayBillRequested);
  }

  final GetWalletUseCase _getWallet;
  final GetTransactionHistoryUseCase _getTransactionHistory;
  final SendMoneyUseCase _sendMoney;
  final BuyAirtimeUseCase _buyAirtime;
  final PayBillUseCase _payBill;

  Future<void> _onLoadRequested(WalletLoadRequested event, Emitter<WalletState> emit) async {
    emit(state.copyWith(loadStatus: WalletLoadStatus.loading));
    final walletResult = await _getWallet(const NoParams());
    final historyResult = await _getTransactionHistory(const NoParams());
    walletResult.fold(
      (failure) => emit(state.copyWith(loadStatus: WalletLoadStatus.loadFailure)),
      (wallet) => emit(
        state.copyWith(
          loadStatus: WalletLoadStatus.loaded,
          wallet: wallet,
          transactions: historyResult.getOrElse(() => state.transactions),
        ),
      ),
    );
  }

  void _onVisibilityToggled(WalletBalanceVisibilityToggled event, Emitter<WalletState> emit) {
    emit(state.copyWith(isBalanceVisible: !state.isBalanceVisible));
  }

  Future<void> _onSendMoneyRequested(
    WalletSendMoneyRequested event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(actionStatus: WalletActionStatus.inProgress, clearActionMessage: true));
    final result = await _sendMoney(
      SendMoneyParams(recipient: event.recipient, amount: event.amount),
    );
    await result.fold(
      (failure) async => emit(
        state.copyWith(actionStatus: WalletActionStatus.failure, actionMessage: failure.message),
      ),
      (wallet) async => _emitActionSuccess(emit, wallet),
    );
  }

  Future<void> _onBuyAirtimeRequested(
    WalletBuyAirtimeRequested event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(actionStatus: WalletActionStatus.inProgress, clearActionMessage: true));
    final result = await _buyAirtime(
      BuyAirtimeParams(phoneNumber: event.phoneNumber, amount: event.amount),
    );
    await result.fold(
      (failure) async => emit(
        state.copyWith(actionStatus: WalletActionStatus.failure, actionMessage: failure.message),
      ),
      (wallet) async => _emitActionSuccess(emit, wallet),
    );
  }

  Future<void> _onPayBillRequested(WalletPayBillRequested event, Emitter<WalletState> emit) async {
    emit(state.copyWith(actionStatus: WalletActionStatus.inProgress, clearActionMessage: true));
    final result = await _payBill(
      PayBillParams(biller: event.biller, accountNumber: event.accountNumber, amount: event.amount),
    );
    await result.fold(
      (failure) async => emit(
        state.copyWith(actionStatus: WalletActionStatus.failure, actionMessage: failure.message),
      ),
      (wallet) async => _emitActionSuccess(emit, wallet),
    );
  }

  // Shared by every successful action: refresh the transaction history
  // too, so the new entry shows up immediately without a separate
  // manual refresh.
  Future<void> _emitActionSuccess(Emitter<WalletState> emit, Wallet wallet) async {
    final historyResult = await _getTransactionHistory(const NoParams());
    emit(
      state.copyWith(
        actionStatus: WalletActionStatus.success,
        wallet: wallet,
        transactions: historyResult.getOrElse(() => state.transactions),
        clearActionMessage: true,
      ),
    );
  }
}
