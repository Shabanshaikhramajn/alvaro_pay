import 'package:dartz/dartz.dart';

import 'package:alvaro_pay/core/error/failures.dart';
import 'package:alvaro_pay/features/wallet/domain/entities/wallet.dart';
import 'package:alvaro_pay/features/wallet/domain/entities/wallet_transaction.dart';

abstract class WalletRepository {
  Future<Either<Failure, Wallet>> getWallet();

  Future<Either<Failure, Wallet>> sendMoney({required String recipient, required double amount});

  Future<Either<Failure, Wallet>> buyAirtime({required String phoneNumber, required double amount});

  Future<Either<Failure, Wallet>> payBill({
    required String biller,
    required String accountNumber,
    required double amount,
  });

  // Most recent first.
  Future<Either<Failure, List<WalletTransaction>>> getTransactionHistory();
}
