import 'package:flutter/widgets.dart';

/// A widget who memoize a value.
class MemoizedBuilder<T> extends StatefulWidget {
  /// Creates a [MemoizedBuilder].
  const MemoizedBuilder({
    @required this.valueBuilder,
    @required this.builder,
    Key key,
  })  : assert(valueBuilder != null),
        assert(builder != null),
        super(key: key);

  /// The builder function to build a value.
  final MemoizedValueBuilder<T> valueBuilder;

  /// The widget builder function.
  final MemoizedWidgetBuilder<T> builder;

  @override
  State<StatefulWidget> createState() => _MemorizedBuilderState<T>();
}

typedef MemoizedValueBuilder<T> = T Function(BuildContext, T);

typedef MemoizedWidgetBuilder<T> = Widget Function(BuildContext, T);

class _MemorizedBuilderState<T> extends State<MemoizedBuilder> {
  T value;

  @override
  void initState() {
    super.initState();

    value = widget.valueBuilder(context, null);
  }

  @override
  void didUpdateWidget(MemoizedBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    value = widget.valueBuilder(context, value);
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, value);
}
