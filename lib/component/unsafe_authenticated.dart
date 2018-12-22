import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meta/meta.dart';
import '../entity/user.dart';
import '../model/authentication_model.dart';

class UnsafeAuthenticated extends StatelessWidget {
  final Builder builder;

  UnsafeAuthenticated({
    Key key,
    @required this.builder,
  })  : assert(builder != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final authenticationModel = Provider.of<AuthenticationModel>(context);

    return StreamBuilder<User>(
      stream: authenticationModel.onUserChanged,
      initialData: authenticationModel.user,
      builder: (_, snapshot) => builder(context, snapshot.requireData),
    );
  }
}

typedef Widget Builder(BuildContext context, User user);
