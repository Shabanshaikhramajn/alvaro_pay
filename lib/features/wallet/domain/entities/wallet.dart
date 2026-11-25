import 'package:equatable/equatable.dart';

class Wallet extends Equatable {
  const Wallet({required this.balance, required this.currencySymbol});

  final double balance;
  final String currencySymbol;

  Wallet copyWith({double? balance}) {
    return Wallet(balance: balance ?? this.balance, currencySymbol: currencySymbol);
  }

  @override
  List<Object?> get props => <Object?>[balance, currencySymbol];
}
