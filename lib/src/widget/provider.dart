import 'package:flutter/widgets.dart';

class Provider<T> extends InheritedWidget {
  Provider({
    @required this.value,
    @required this.child,
    UpdateShouldNotify<T> updateShouldNotify,
    Key key,
  })  : assert(value != null),
        assert(child != null),
        _updateShouldNotify = updateShouldNotify,
        super(key: key, child: child);

  final T value;

  final Widget child;

  final UpdateShouldNotify<T> _updateShouldNotify;

  @override
  bool updateShouldNotify(Provider<T> oldWidget) {
    if (_updateShouldNotify != null) {
      return _updateShouldNotify(oldWidget, this);
    }

    return oldWidget.value != value;
  }

  static T of<T>(BuildContext context, {bool listen = true}) {
    final type = _getType<Provider<T>>();

    final Provider<T> widget = listen
        ? context.inheritFromWidgetOfExactType(type)
        : context.ancestorInheritedElementForWidgetOfExactType(type)?.widget;

    return widget?.value;
  }
}

typedef UpdateShouldNotify<T> = bool Function(
  Provider<T> oldWidget,
  Provider<T> widget,
);

class Consumer<T> extends StatelessWidget {
  Consumer({
    @required this.builder,
    Key key,
  })  : assert(builder != null),
        super(key: key);

  final ValueWidgetBuilder<T> builder;

  @override
  Widget build(BuildContext context) {
    final value = Provider.of<T>(context);

    return builder(context, value);
  }
}

typedef ValueWidgetBuilder<T> = Widget Function(BuildContext context, T value);

Type _getType<T>() => T;
