import 'package:dartz/dartz.dart';

import 'package:alvaro_pay/core/error/exceptions.dart';
import 'package:alvaro_pay/core/error/failures.dart';
import 'package:alvaro_pay/features/auth/data/datasources/auth_mock_datasource.dart';
import 'package:alvaro_pay/features/auth/data/datasources/auth_session_local_datasource.dart';
import 'package:alvaro_pay/features/auth/data/models/app_user_model.dart';
import 'package:alvaro_pay/features/auth/domain/entities/app_user.dart';
import 'package:alvaro_pay/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._dataSource, this._sessionDataSource);

  final AuthMockDataSource _dataSource;
  final AuthSessionLocalDataSource _sessionDataSource;

  @override
  Future<Either<Failure, AppUser>> login({
    required String email,
    required String password,
  }) async {
    try {
      final AppUserModel user = await _dataSource.login(email: email, password: password);
      await _sessionDataSource.saveSession(user);
      return Right(user);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppUser>> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final AppUserModel user = await _dataSource.signUp(
        fullName: fullName,
        email: email,
        password: password,
      );
      await _sessionDataSource.saveSession(user);
      return Right(user);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<AppUser?> getCachedUser() => _sessionDataSource.loadSession();

  @override
  Future<void> clearSession() => _sessionDataSource.clearSession();
}
