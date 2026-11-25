import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:alvaro_pay/core/error/failures.dart';
import 'package:alvaro_pay/core/usecases/usecase.dart';
import 'package:alvaro_pay/features/wallet/domain/entities/wallet.dart';
import 'package:alvaro_pay/features/wallet/domain/repositories/wallet_repository.dart';

class PayBillParams extends Equatable {
  const PayBillParams({
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

class PayBillUseCase implements UseCase<Wallet, PayBillParams> {
  const PayBillUseCase(this._repository);

  final WalletRepository _repository;

  @override
  Future<Either<Failure, Wallet>> call(PayBillParams params) {
    return _repository.payBill(
      biller: params.biller,
      accountNumber: params.accountNumber,
      amount: params.amount,
    );
  }
}
