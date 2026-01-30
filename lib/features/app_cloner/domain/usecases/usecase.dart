import 'package:dartz/dartz.dart';
import 'package:kloner/core/errors/failures.dart';

/// Base class for all use cases (Either<Failure, Success>)
abstract class UseCase<Type, Params> {
  const UseCase();
  
  Future<Either<Failure, Type>> call(Params params);
}

/// No parameters needed for use case
class NoParams {}

/// Helper extension for cleaner Either handling
extension EitherExtension<T> on Either<Failure, T> {
  T? get value => fold((l) => null, (r) => r);
  Failure? get failure => fold((l) => l, (r) => null);
}
