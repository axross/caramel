import 'package:flutter/material.dart';

class ModalLoadingIndicator extends StatelessWidget {
  const ModalLoadingIndicator({
    this.child,
    Key key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          child,
          const Opacity(
            opacity: 0.5,
            child: ModalBarrier(
              dismissible: false,
              color: Colors.grey,
            ),
          ),
          const Center(
            child: CircularProgressIndicator(),
          ),
        ],
      );
}
