import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meta/meta.dart';
import '../entity/user.dart';
import '../model/authentication_model.dart';

class Authenticated extends StatelessWidget {
  final AuthenticatedBuilder authenticatedBuilder;
  final UnauthenticatedBuilder unauthenticatedBuilder;

  Authenticated(
      {Key key,
      @required this.authenticatedBuilder,
      @required this.unauthenticatedBuilder})
      : assert(authenticatedBuilder != null),
        assert(unauthenticatedBuilder != null),
        super(key: key);

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

typedef Widget AuthenticatedBuilder(BuildContext context, User user);
typedef Widget UnauthenticatedBuilder(BuildContext context);
