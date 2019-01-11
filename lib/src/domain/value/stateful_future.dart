import 'dart:async' show FutureOr;

class StatefulFuture<T> implements Future<T> {
  StatefulFuture(Future<T> future)
      : assert(future != null),
        _future = future;

  final Future<T> _future;

  @override
  Future<R> then<R>(
    FutureOr<R> Function(T value) onValue, {
    Function onError,
  }) =>
      _future.then((result) {
        _value = result;

        return result;
      }).then(onValue, onError: onError);

  @override
  Future<T> catchError(Function onError, {bool Function(Object error) test}) =>
      _future.catchError(onError, test: test);

  @override
  Future<T> whenComplete(FutureOr action()) => _future.whenComplete(action);

  @override
  Stream<T> asStream() => _future.asStream();

  @override
  Future<T> timeout(Duration timeLimit, {FutureOr<T> Function() onTimeout}) =>
      _future.timeout(timeLimit, onTimeout: onTimeout);

  T _value;

  T get value => _value;
}
