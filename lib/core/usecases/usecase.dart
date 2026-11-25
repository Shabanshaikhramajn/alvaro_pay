import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:alvaro_pay/core/error/failures.dart';

// A single-purpose action with one input and one Either<Failure, T>
// output - every usecase in the app implements this.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

// For a usecase that needs no input (e.g. "get the current wallet").
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => <Object?>[];
}
