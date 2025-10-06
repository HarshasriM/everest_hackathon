import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// Type alias for Result type using Either from dartz
/// Left represents Failure, Right represents Success
typedef Result<T> = Either<Failure, T>;

/// Extension methods for Result type
extension ResultExtension<T> on Result<T> {
  /// Check if the result is a success
  bool get isSuccess => isRight();
  
  /// Check if the result is a failure
  bool get isFailure => isLeft();
  
  /// Get the success value or null
  T? get successOrNull => fold(
    (failure) => null,
    (success) => success,
  );
  
  /// Get the failure or null
  Failure? get failureOrNull => fold(
    (failure) => failure,
    (success) => null,
  );
  
  /// Execute a function when the result is success
  Result<T> onSuccess(void Function(T value) action) {
    if (isSuccess) {
      fold(
        (_) {},
        (value) => action(value),
      );
    }
    return this;
  }
  
  /// Execute a function when the result is failure
  Result<T> onFailure(void Function(Failure failure) action) {
    if (isFailure) {
      fold(
        (failure) => action(failure),
        (_) {},
      );
    }
    return this;
  }
}
