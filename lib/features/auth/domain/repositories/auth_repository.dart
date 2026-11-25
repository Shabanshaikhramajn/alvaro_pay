import 'package:dartz/dartz.dart';

import 'package:alvaro_pay/core/error/failures.dart';
import 'package:alvaro_pay/features/auth/domain/entities/app_user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AppUser>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, AppUser>> signUp({
    required String fullName,
    required String email,
    required String password,
  });

  // The user saved from a previous successful login/sign-up, if any -
  // lets the app skip straight to the wallet on launch.
  Future<AppUser?> getCachedUser();

  Future<void> clearSession();
}
