import 'package:alvaro_pay/features/wallet/domain/entities/wallet_transaction.dart';

class WalletTransactionModel extends WalletTransaction {
  const WalletTransactionModel({
    required super.id,
    required super.type,
    required super.counterpart,
    required super.amount,
    required super.timestamp,
  });
}
