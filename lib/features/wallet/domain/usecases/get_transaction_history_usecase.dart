import 'package:dartz/dartz.dart';

import 'package:alvaro_pay/core/error/failures.dart';
import 'package:alvaro_pay/core/usecases/usecase.dart';
import 'package:alvaro_pay/features/wallet/domain/entities/wallet_transaction.dart';
import 'package:alvaro_pay/features/wallet/domain/repositories/wallet_repository.dart';

class GetTransactionHistoryUseCase implements UseCase<List<WalletTransaction>, NoParams> {
  const GetTransactionHistoryUseCase(this._repository);

  final WalletRepository _repository;

  @override
  Future<Either<Failure, List<WalletTransaction>>> call(NoParams params) =>
      _repository.getTransactionHistory();
}
