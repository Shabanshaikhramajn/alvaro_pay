import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:alvaro_pay/core/error/failures.dart';
import 'package:alvaro_pay/features/wallet/domain/entities/wallet.dart';
import 'package:alvaro_pay/features/wallet/domain/entities/wallet_transaction.dart';
import 'package:alvaro_pay/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:alvaro_pay/features/wallet/domain/usecases/buy_airtime_usecase.dart';
import 'package:alvaro_pay/features/wallet/domain/usecases/get_transaction_history_usecase.dart';
import 'package:alvaro_pay/features/wallet/domain/usecases/get_wallet_usecase.dart';
import 'package:alvaro_pay/features/wallet/domain/usecases/pay_bill_usecase.dart';
import 'package:alvaro_pay/features/wallet/domain/usecases/send_money_usecase.dart';
import 'package:alvaro_pay/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:alvaro_pay/features/wallet/presentation/bloc/wallet_event.dart';
import 'package:alvaro_pay/features/wallet/presentation/bloc/wallet_state.dart';

class _MockWalletRepository extends Mock implements WalletRepository {}

void main() {
  late _MockWalletRepository repository;
  late WalletBloc bloc;

  const Wallet wallet = Wallet(balance: 2500, currencySymbol: '\$');
  const Wallet walletAfterSend = Wallet(balance: 2400, currencySymbol: '\$');

  setUp(() {
    repository = _MockWalletRepository();
    // Every load and every successful action re-fetches history, so stub
    // it here once rather than in each test.
    when(() => repository.getTransactionHistory())
        .thenAnswer((_) async => const Right(<WalletTransaction>[]));
    bloc = WalletBloc(
      getWallet: GetWalletUseCase(repository),
      getTransactionHistory: GetTransactionHistoryUseCase(repository),
      sendMoney: SendMoneyUseCase(repository),
      buyAirtime: BuyAirtimeUseCase(repository),
      payBill: PayBillUseCase(repository),
    );
  });

  tearDown(() => bloc.close());

  blocTest<WalletBloc, WalletState>(
    'loads the wallet balance on WalletLoadRequested',
    setUp: () {
      when(() => repository.getWallet()).thenAnswer((_) async => const Right(wallet));
    },
    build: () => bloc,
    act: (bloc) => bloc.add(const WalletLoadRequested()),
    expect: () => <Matcher>[
      isA<WalletState>().having((s) => s.loadStatus, 'loadStatus', WalletLoadStatus.loading),
      isA<WalletState>()
          .having((s) => s.loadStatus, 'loadStatus', WalletLoadStatus.loaded)
          .having((s) => s.wallet, 'wallet', wallet),
    ],
  );

  blocTest<WalletBloc, WalletState>(
    'sending money updates the balance on success',
    setUp: () {
      when(
        () => repository.sendMoney(
          recipient: any(named: 'recipient'),
          amount: any(named: 'amount'),
        ),
      ).thenAnswer((_) async => const Right(walletAfterSend));
    },
    build: () => bloc,
    act: (bloc) =>
        bloc.add(const WalletSendMoneyRequested(recipient: 'friend@example.com', amount: 100)),
    expect: () => <Matcher>[
      isA<WalletState>().having((s) => s.actionStatus, 'actionStatus', WalletActionStatus.inProgress),
      isA<WalletState>()
          .having((s) => s.actionStatus, 'actionStatus', WalletActionStatus.success)
          .having((s) => s.wallet, 'wallet', walletAfterSend),
    ],
  );

  blocTest<WalletBloc, WalletState>(
    'sending more than the balance surfaces the insufficient-balance message',
    setUp: () {
      when(
        () => repository.sendMoney(
          recipient: any(named: 'recipient'),
          amount: any(named: 'amount'),
        ),
      ).thenAnswer((_) async => const Left(InsufficientBalanceFailure('Insufficient balance.')));
    },
    build: () => bloc,
    act: (bloc) => bloc.add(
      const WalletSendMoneyRequested(recipient: 'friend@example.com', amount: 999999),
    ),
    expect: () => <Matcher>[
      isA<WalletState>().having((s) => s.actionStatus, 'actionStatus', WalletActionStatus.inProgress),
      isA<WalletState>()
          .having((s) => s.actionStatus, 'actionStatus', WalletActionStatus.failure)
          .having((s) => s.actionMessage, 'actionMessage', 'Insufficient balance.'),
    ],
  );
}
