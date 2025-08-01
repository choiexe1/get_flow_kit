import 'exceptions/base_exception.dart';

sealed class Result<T, E extends BaseException> {
  const Result();
}

final class Success<T, E extends BaseException> extends Result<T, E> {
  const Success(this.value);
  final T value;
}

final class Failure<T, E extends BaseException> extends Result<T, E> {
  const Failure(this.exception);
  final E exception;
}
