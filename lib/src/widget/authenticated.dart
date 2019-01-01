import 'package:caramel/entities.dart';
import 'package:caramel/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meta/meta.dart';

class Authenticated extends StatelessWidget {
  const Authenticated({
    @required this.authenticatedBuilder,
    @required this.unauthenticatedBuilder,
    Key key,
  })  : assert(authenticatedBuilder != null),
        assert(unauthenticatedBuilder != null),
        super(key: key);

  final AuthenticatedBuilder authenticatedBuilder;
  final UnauthenticatedBuilder unauthenticatedBuilder;

  @override
  Widget build(BuildContext context) {
    final authenticationModel = Provider.of<AuthenticationModel>(context);

    return StreamBuilder<User>(
      stream: authenticationModel.onUserChanged,
      initialData: authenticationModel.user,
      builder: (_, snapshot) => snapshot.hasData
          ? authenticatedBuilder(context, snapshot.data)
          : unauthenticatedBuilder(context),
    );
  }
}

typedef AuthenticatedBuilder = Widget Function(BuildContext context, User user);
typedef UnauthenticatedBuilder = Widget Function(BuildContext context);
