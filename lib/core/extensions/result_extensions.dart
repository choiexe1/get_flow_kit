import 'package:get_flow_kit/core/base_exception.dart';
import 'package:get_flow_kit/core/result.dart';

/// Result 패턴의 유틸리티 메서드를 제공하는 확장
///
/// 이 확장은 다음과 같은 기능을 제공합니다:
/// - 상태 확인 (isSuccess, isFailure)
/// - 안전한 값 추출 (valueOrNull, getOrElse)
/// - 패턴 매칭 (fold)
/// - 값 변환 (map, mapError)
/// - 체이닝 (flatMap)
/// - 부수효과 (onSuccess, onFailure)
extension ResultExtensions<T, E extends BaseException> on Result<T, E> {
  /// 성공 상태인지 확인합니다.
  ///
  /// ```dart
  /// final result = Success(42);
  /// print(result.isSuccess); // true
  /// ```
  bool get isSuccess => this is Success<T, E>;

  /// 실패 상태인지 확인합니다.
  ///
  /// ```dart
  /// final result = Failure(NetworkException());
  /// print(result.isFailure); // true
  /// ```
  bool get isFailure => this is Failure<T, E>;

  /// 성공시 값을 반환하고, 실패시 null을 반환합니다.
  ///
  /// ```dart
  /// final result = Success(42);
  /// print(result.valueOrNull); // 42
  ///
  /// final errorResult = Failure(NetworkException());
  /// print(errorResult.valueOrNull); // null
  /// ```
  T? get valueOrNull => switch (this) {
    Success(value: final v) => v,
    Failure() => null,
  };

  /// 성공시 값을 반환하고, 실패시 기본값을 반환합니다.
  ///
  /// ```dart
  /// final result = Failure(NetworkException());
  /// final value = result.getOrElse(() => 'default');
  /// print(value); // 'default'
  /// ```
  T getOrElse(T Function() defaultValue) => switch (this) {
    Success(value: final v) => v,
    Failure() => defaultValue(),
  };

  /// 성공시 값을 반환하고, 실패시 제공된 기본값을 반환합니다.
  ///
  /// ```dart
  /// final result = Failure(NetworkException());
  /// final value = result.getOrDefault('default');
  /// print(value); // 'default'
  /// ```
  T getOrDefault(T defaultValue) => switch (this) {
    Success(value: final v) => v,
    Failure() => defaultValue,
  };

  /// 성공과 실패 케이스를 모두 처리하여 단일 값을 반환합니다.
  ///
  /// ```dart
  /// final result = Success(42);
  /// final message = result.fold(
  ///   onSuccess: (value) => 'Success: $value',
  ///   onFailure: (error) => 'Error: ${error.message}',
  /// );
  /// print(message); // 'Success: 42'
  /// ```
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(E exception) onFailure,
  }) => switch (this) {
    Success(value: final v) => onSuccess(v),
    Failure(exception: final e) => onFailure(e),
  };

  /// fold의 간단한 버전으로, when 키워드를 사용합니다.
  ///
  /// ```dart
  /// final result = Success(42);
  /// final doubled = result.when(
  ///   success: (value) => value * 2,
  ///   failure: (error) => 0,
  /// );
  /// ```
  R when<R>({
    required R Function(T value) success,
    required R Function(E exception) failure,
  }) => fold(onSuccess: success, onFailure: failure);

  /// 성공시 값을 변환하고, 실패시 에러를 그대로 유지합니다.
  ///
  /// ```dart
  /// final result = Success(42);
  /// final doubled = result.map((value) => value * 2);
  /// print(doubled.valueOrNull); // 84
  /// ```
  Result<R, E> map<R>(R Function(T value) transform) => switch (this) {
    Success(value: final v) => Success(transform(v)),
    Failure(exception: final e) => Failure(e),
  };

  /// 실패시 에러를 변환하고, 성공시 값을 그대로 유지합니다.
  ///
  /// ```dart
  /// final result = Failure(NetworkException());
  /// final transformed = result.mapError((error) => AuthException());
  /// ```
  Result<T, F> mapError<F extends BaseException>(
    F Function(E error) transform,
  ) => switch (this) {
    Success(value: final v) => Success(v),
    Failure(exception: final e) => Failure(transform(e)),
  };

  /// 성공시 다른 Result를 반환하는 함수를 적용합니다. (flatMap)
  ///
  /// ```dart
  /// Result<int, E> parseAndDouble(String input) {
  ///   return parseNumber(input).flatMap((num) => Success(num * 2));
  /// }
  /// ```
  Result<R, E> flatMap<R>(Result<R, E> Function(T value) transform) =>
      switch (this) {
        Success(value: final v) => transform(v),
        Failure(exception: final e) => Failure(e),
      };

  /// flatMap의 별칭입니다.
  Result<R, E> andThen<R>(Result<R, E> Function(T value) transform) =>
      flatMap(transform);

  /// 실패시 기본값으로 복구합니다.
  ///
  /// ```dart
  /// final result = Failure(NetworkException());
  /// final recovered = result.recover((error) => 'fallback');
  /// print(recovered.valueOrNull); // 'fallback'
  /// ```
  Result<T, E> recover(T Function(E error) recovery) => switch (this) {
    Success(value: final v) => Success(v),
    Failure(exception: final e) => Success(recovery(e)),
  };

  /// 실패시 다른 Result로 복구합니다.
  ///
  /// ```dart
  /// final result = Failure(NetworkException());
  /// final recovered = result.recoverWith((error) => Success('fallback'));
  /// ```
  Result<T, E> recoverWith(Result<T, E> Function(E error) recovery) =>
      switch (this) {
        Success(value: final v) => Success(v),
        Failure(exception: final e) => recovery(e),
      };

  /// 성공시 부수효과를 실행하고 자신을 반환합니다.
  ///
  /// ```dart
  /// final result = Success(42)
  ///   .onSuccess((value) => print('Got: $value'))
  ///   .map((value) => value * 2);
  /// ```
  Result<T, E> onSuccess(void Function(T value) action) {
    if (this case Success(value: final v)) {
      action(v);
    }
    return this;
  }

  /// 실패시 부수효과를 실행하고 자신을 반환합니다.
  ///
  /// ```dart
  /// final result = Failure(NetworkException())
  ///   .onFailure((error) => print('Error: ${error.message}'))
  ///   .recover((error) => 'fallback');
  /// ```
  Result<T, E> onFailure(void Function(E error) action) {
    if (this case Failure(exception: final e)) {
      action(e);
    }
    return this;
  }

  /// 조건에 따라 값을 필터링합니다.
  ///
  /// ```dart
  /// final result = Success(42);
  /// final filtered = result.filter(
  ///   (value) => value > 50,
  ///   () => ValidationException('Value too small')
  /// );
  /// print(filtered.isFailure); // true
  /// ```
  Result<T, E> filter(bool Function(T value) predicate, E Function() onFalse) =>
      switch (this) {
        Success(value: final v) =>
          predicate(v) ? Success(v) : Failure(onFalse()),
        Failure(exception: final e) => Failure(e),
      };

  /// 값이 null이 아닌 경우에만 성공을 유지합니다.
  Result<T, E> whereNotNull(E Function() onNull) => switch (this) {
    Success(value: final v) => v != null ? Success(v) : Failure(onNull()),
    Failure(exception: final e) => Failure(e),
  };
}

/// 비동기 Result를 위한 확장
extension AsyncResultExtensions<T, E extends BaseException>
    on Future<Result<T, E>> {
  /// 비동기 Result에 map을 적용합니다.
  Future<Result<R, E>> mapAsync<R>(R Function(T value) transform) async {
    final result = await this;
    return result.map(transform);
  }

  /// 비동기 Result에 flatMap을 적용합니다.
  Future<Result<R, E>> flatMapAsync<R>(
    Future<Result<R, E>> Function(T value) transform,
  ) async {
    final result = await this;
    return switch (result) {
      Success(value: final v) => await transform(v),
      Failure(exception: final e) => Failure(e),
    };
  }

  /// 비동기 Result를 기본값으로 해결합니다.
  Future<T> getOrElseAsync(T Function() defaultValue) async {
    final result = await this;
    return result.getOrElse(defaultValue);
  }
}

/// 여러 Result를 조합하는 유틸리티 함수들
class ResultUtils {
  /// 모든 Result가 성공인 경우에만 성공을 반환합니다.
  ///
  /// ```dart
  /// final results = [Success(1), Success(2), Success(3)];
  /// final combined = ResultUtils.combine(results, (values) => values.sum);
  /// ```
  static Result<R, E> combine<T, E extends BaseException, R>(
    List<Result<T, E>> results,
    R Function(List<T> values) combiner,
  ) {
    final values = <T>[];

    for (final result in results) {
      switch (result) {
        case Success(value: final v):
          values.add(v);
        case Failure(exception: final e):
          return Failure(e);
      }
    }

    return Success(combiner(values));
  }

  /// 첫 번째 성공하는 Result를 반환합니다.
  ///
  /// ```dart
  /// final results = [Failure(err1), Success(42), Failure(err2)];
  /// final first = ResultUtils.firstSuccess(results);
  /// print(first.valueOrNull); // 42
  /// ```
  static Result<T, E> firstSuccess<T, E extends BaseException>(
    List<Result<T, E>> results,
    E Function() onAllFailed,
  ) {
    for (final result in results) {
      if (result.isSuccess) return result;
    }
    return Failure(onAllFailed());
  }
}
