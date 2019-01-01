import 'package:caramel/widgets.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import './authenticated.dart';

class AuthenticatedScreen extends StatelessWidget {
  const AuthenticatedScreen({
    @required this.builder,
    Key key,
  })  : assert(builder != null),
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
          title: const Text('Need to sign in'),
        ),
        body: Container(
          child: const Center(
            child: Text('Please sign in.'),
          ),
        ),
      );
}
