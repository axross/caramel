import 'package:caramel/widgets.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import './authenticated.dart';

class AuthenticatedScreen extends StatelessWidget {
  AuthenticatedScreen({Key key, @required this.builder})
      : assert(builder != null),
        super(key: key);

  final AuthenticatedBuilder builder;

  @override
  Widget build(BuildContext context) => Authenticated(
        authenticatedBuilder: builder,
        unauthenticatedBuilder: (_) => _UnauthenticatedScreen(),
      );
}

class _UnauthenticatedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Need to sign in'),
        ),
        body: Container(
          child: Center(
            child: Text('Please sign in.'),
          ),
        ),
      );
}
