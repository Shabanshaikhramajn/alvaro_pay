import 'package:dartz/dartz.dart';

import 'package:alvaro_pay/core/error/failures.dart';
import 'package:alvaro_pay/core/usecases/usecase.dart';
import 'package:alvaro_pay/features/wallet/domain/entities/wallet.dart';
import 'package:alvaro_pay/features/wallet/domain/repositories/wallet_repository.dart';

class GetWalletUseCase implements UseCase<Wallet, NoParams> {
  const GetWalletUseCase(this._repository);

  final WalletRepository _repository;

  @override
  Future<Either<Failure, Wallet>> call(NoParams params) => _repository.getWallet();
}
