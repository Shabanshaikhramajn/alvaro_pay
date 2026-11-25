import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:alvaro_pay/core/error/failures.dart';
import 'package:alvaro_pay/core/usecases/usecase.dart';
import 'package:alvaro_pay/features/auth/domain/entities/app_user.dart';
import 'package:alvaro_pay/features/auth/domain/repositories/auth_repository.dart';

class LoginParams extends Equatable {
  const LoginParams({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => <Object?>[email, password];
}

class LoginUseCase implements UseCase<AppUser, LoginParams> {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, AppUser>> call(LoginParams params) {
    return _repository.login(email: params.email, password: params.password);
  }
}
