import 'package:dartz/dartz.dart';

import 'package:alvaro_pay/core/error/exceptions.dart';
import 'package:alvaro_pay/core/error/failures.dart';
import 'package:alvaro_pay/features/wallet/data/datasources/wallet_mock_datasource.dart';
import 'package:alvaro_pay/features/wallet/domain/entities/wallet.dart';
import 'package:alvaro_pay/features/wallet/domain/entities/wallet_transaction.dart';
import 'package:alvaro_pay/features/wallet/domain/repositories/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  const WalletRepositoryImpl(this._dataSource);

  final WalletMockDataSource _dataSource;

  @override
  Future<Either<Failure, Wallet>> getWallet() async {
    try {
      return Right(await _dataSource.getWallet());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Wallet>> sendMoney({
    required String recipient,
    required double amount,
  }) async {
    try {
      return Right(await _dataSource.sendMoney(recipient: recipient, amount: amount));
    } on InsufficientBalanceException catch (e) {
      return Left(InsufficientBalanceFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Wallet>> buyAirtime({
    required String phoneNumber,
    required double amount,
  }) async {
    try {
      return Right(await _dataSource.buyAirtime(phoneNumber: phoneNumber, amount: amount));
    } on InsufficientBalanceException catch (e) {
      return Left(InsufficientBalanceFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Wallet>> payBill({
    required String biller,
    required String accountNumber,
    required double amount,
  }) async {
    try {
      return Right(
        await _dataSource.payBill(biller: biller, accountNumber: accountNumber, amount: amount),
      );
    } on InsufficientBalanceException catch (e) {
      return Left(InsufficientBalanceFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WalletTransaction>>> getTransactionHistory() async {
    try {
      return Right(await _dataSource.getTransactionHistory());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
