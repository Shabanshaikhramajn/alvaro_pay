import 'package:alvaro_pay/features/auth/domain/entities/app_user.dart';
import 'package:alvaro_pay/features/auth/domain/repositories/auth_repository.dart';

// Not a standard UseCase<Either<Failure, T>, Params> - there's no
// "failure" case for "no session found", just an absent user.
class GetCachedSessionUseCase {
  const GetCachedSessionUseCase(this._repository);

  final AuthRepository _repository;

  Future<AppUser?> call() => _repository.getCachedUser();
}
