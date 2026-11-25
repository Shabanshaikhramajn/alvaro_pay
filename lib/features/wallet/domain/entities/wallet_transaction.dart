import 'package:equatable/equatable.dart';

enum TransactionType { sendMoney, buyAirtime, payBill }

class WalletTransaction extends Equatable {
  const WalletTransaction({
    required this.id,
    required this.type,
    required this.counterpart,
    required this.amount,
    required this.timestamp,
  });

  final String id;
  final TransactionType type;

  // Who/what this transaction was with: the recipient for a transfer,
  // the phone number for an airtime top-up, the biller for a bill payment.
  final String counterpart;
  final double amount;
  final DateTime timestamp;

  @override
  List<Object?> get props => <Object?>[id, type, counterpart, amount, timestamp];
}
