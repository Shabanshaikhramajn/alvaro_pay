import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:alvaro_pay/core/error/failures.dart';
import 'package:alvaro_pay/core/usecases/usecase.dart';
import 'package:alvaro_pay/features/wallet/domain/entities/wallet.dart';
import 'package:alvaro_pay/features/wallet/domain/repositories/wallet_repository.dart';

class BuyAirtimeParams extends Equatable {
  const BuyAirtimeParams({required this.phoneNumber, required this.amount});

  final String phoneNumber;
  final double amount;

  @override
  List<Object?> get props => <Object?>[phoneNumber, amount];
}

class BuyAirtimeUseCase implements UseCase<Wallet, BuyAirtimeParams> {
  const BuyAirtimeUseCase(this._repository);

  final WalletRepository _repository;

  @override
  Future<Either<Failure, Wallet>> call(BuyAirtimeParams params) {
    return _repository.buyAirtime(phoneNumber: params.phoneNumber, amount: params.amount);
  }
}
