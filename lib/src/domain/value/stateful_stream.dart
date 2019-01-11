import 'dart:async'
    show
        EventSink,
        FutureOr,
        StreamConsumer,
        StreamSubscription,
        StreamTransformer;

class StatefulStream<T> implements Stream<T> {
  StatefulStream(Stream<T> stream)
      : assert(stream != null),
        _stream = stream {
    _stream.listen((event) {
      _latest = event;
    });
  }

  final Stream<T> _stream;

  @override
  bool get isBroadcast => _stream.isBroadcast;

  @override
  Stream<T> asBroadcastStream({
    void onListen(StreamSubscription<T> subscription),
    void onCancel(StreamSubscription<T> subscription),
  }) =>
      _stream.asBroadcastStream(onListen: onListen, onCancel: onCancel);

  @override
  StreamSubscription<T> listen(void onData(T event),
          {Function onError, void onDone(), bool cancelOnError}) =>
      _stream.listen(onData,
          onError: onError, onDone: onDone, cancelOnError: cancelOnError);

  @override
  Stream<T> where(bool test(T event)) => _stream.where(test);

  @override
  Stream<S> map<S>(S convert(T event)) => _stream.map<S>(convert);

  @override
  Stream<E> asyncMap<E>(FutureOr<E> convert(T event)) =>
      _stream.asyncMap<E>(convert);
  @override
  Stream<E> asyncExpand<E>(Stream<E> convert(T event)) => asyncExpand(convert);

  @override
  Stream<T> handleError(Function onError, {bool test(error)}) =>
      _stream.handleError(onError, test: test);

  @override
  Stream<S> expand<S>(Iterable<S> convert(T element)) =>
      _stream.expand(convert);

  @override
  Future pipe(StreamConsumer<T> streamConsumer) => _stream.pipe(streamConsumer);

  @override
  Stream<S> transform<S>(StreamTransformer<T, S> streamTransformer) =>
      _stream.transform<S>(streamTransformer);

  @override
  Future<T> reduce(T combine(T previous, T element)) => _stream.reduce(combine);

  @override
  Future<S> fold<S>(S initialValue, S combine(S previous, T element)) =>
      _stream.fold<S>(initialValue, combine);

  @override
  Future<String> join([String separator]) => _stream.join(separator);

  @override
  Future<bool> contains(Object needle) => _stream.contains(needle);

  @override
  Future forEach(void action(T element)) => _stream.forEach(action);

  @override
  Future<bool> every(bool test(T element)) => _stream.every(test);

  @override
  Future<bool> any(bool test(T element)) => _stream.any(test);

  @override
  Future<int> get length => _stream.length;

  @override
  Future<bool> get isEmpty => _stream.isEmpty;

  @override
  Stream<R> cast<R>() => _stream.cast<R>();

  @override
  Future<List<T>> toList() => _stream.toList();

  @override
  Future<Set<T>> toSet() => _stream.toSet();

  @override
  Future<E> drain<E>([E futureValue]) => _stream.drain(futureValue);

  @override
  Stream<T> take(int count) => _stream.take(count);

  @override
  Stream<T> takeWhile(bool test(T element)) => _stream.takeWhile(test);

  @override
  Stream<T> skip(int count) => _stream.skip(count);

  @override
  Stream<T> skipWhile(bool test(T element)) => _stream.skipWhile(test);

  @override
  Stream<T> distinct([bool equals(T previous, T next)]) =>
      _stream.distinct(equals);

  @override
  Future<T> get first => _stream.first;

  @override
  Future<T> get last => _stream.last;

  @override
  Future<T> get single => _stream.single;

  @override
  Future<T> firstWhere(bool test(T element), {T orElse()}) =>
      _stream.firstWhere(test, orElse: orElse);

  @override
  Future<T> lastWhere(bool test(T element), {T orElse()}) =>
      _stream.lastWhere(test, orElse: orElse);

  @override
  Future<T> singleWhere(bool test(T element), {T orElse()}) =>
      _stream.singleWhere(test, orElse: orElse);

  @override
  Future<T> elementAt(int index) => _stream.elementAt(index);

  @override
  Stream<T> timeout(Duration timeLimit, {void onTimeout(EventSink<T> sink)}) =>
      _stream.timeout(timeLimit, onTimeout: onTimeout);

  T _latest;

  T get latest => _latest;
}
