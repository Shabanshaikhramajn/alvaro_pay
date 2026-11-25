import 'package:equatable/equatable.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class WalletLoadRequested extends WalletEvent {
  const WalletLoadRequested();
}

class WalletBalanceVisibilityToggled extends WalletEvent {
  const WalletBalanceVisibilityToggled();
}

class WalletSendMoneyRequested extends WalletEvent {
  const WalletSendMoneyRequested({required this.recipient, required this.amount});

  final String recipient;
  final double amount;

  @override
  List<Object?> get props => <Object?>[recipient, amount];
}

class WalletBuyAirtimeRequested extends WalletEvent {
  const WalletBuyAirtimeRequested({required this.phoneNumber, required this.amount});

  final String phoneNumber;
  final double amount;

  @override
  List<Object?> get props => <Object?>[phoneNumber, amount];
}

class WalletPayBillRequested extends WalletEvent {
  const WalletPayBillRequested({
    required this.biller,
    required this.accountNumber,
    required this.amount,
  });

  final String biller;
  final String accountNumber;
  final double amount;

  @override
  List<Object?> get props => <Object?>[biller, accountNumber, amount];
}
