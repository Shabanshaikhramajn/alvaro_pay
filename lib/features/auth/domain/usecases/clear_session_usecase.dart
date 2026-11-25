import 'package:alvaro_pay/features/auth/domain/repositories/auth_repository.dart';

class ClearSessionUseCase {
  const ClearSessionUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call() => _repository.clearSession();
}
