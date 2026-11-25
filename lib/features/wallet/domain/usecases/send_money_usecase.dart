import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:alvaro_pay/core/error/failures.dart';
import 'package:alvaro_pay/core/usecases/usecase.dart';
import 'package:alvaro_pay/features/wallet/domain/entities/wallet.dart';
import 'package:alvaro_pay/features/wallet/domain/repositories/wallet_repository.dart';

class SendMoneyParams extends Equatable {
  const SendMoneyParams({required this.recipient, required this.amount});

  final String recipient;
  final double amount;

  @override
  List<Object?> get props => <Object?>[recipient, amount];
}

class SendMoneyUseCase implements UseCase<Wallet, SendMoneyParams> {
  const SendMoneyUseCase(this._repository);

  final WalletRepository _repository;

  @override
  Future<Either<Failure, Wallet>> call(SendMoneyParams params) {
    return _repository.sendMoney(recipient: params.recipient, amount: params.amount);
  }
}
