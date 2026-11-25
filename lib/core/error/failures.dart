import 'package:equatable/equatable.dart';

// What can go wrong, expressed as typed failures instead of raw
// exceptions, so a Bloc can react to a specific case rather than a
// generic error string.
abstract class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class InsufficientBalanceFailure extends Failure {
  const InsufficientBalanceFailure(super.message);
}
