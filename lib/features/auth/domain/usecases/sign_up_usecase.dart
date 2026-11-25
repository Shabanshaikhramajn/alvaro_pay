import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:alvaro_pay/core/error/failures.dart';
import 'package:alvaro_pay/core/usecases/usecase.dart';
import 'package:alvaro_pay/features/auth/domain/entities/app_user.dart';
import 'package:alvaro_pay/features/auth/domain/repositories/auth_repository.dart';

class SignUpParams extends Equatable {
  const SignUpParams({required this.fullName, required this.email, required this.password});

  final String fullName;
  final String email;
  final String password;

  @override
  List<Object?> get props => <Object?>[fullName, email, password];
}

class SignUpUseCase implements UseCase<AppUser, SignUpParams> {
  const SignUpUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, AppUser>> call(SignUpParams params) {
    return _repository.signUp(
      fullName: params.fullName,
      email: params.email,
      password: params.password,
    );
  }
}
