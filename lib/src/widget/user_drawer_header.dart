import 'package:caramel/widgets.dart';
import 'package:firebase_storage_image/firebase_storage_image.dart';
import 'package:flutter/material.dart';
import './authenticated.dart';

class UserDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Authenticated(
      authenticatedBuilder: (_, user) => UserAccountsDrawerHeader(
            accountName: Text(user.name),
            accountEmail: Text(user.uid),
            currentAccountPicture: CircleAvatar(
              backgroundImage: FirebaseStorageImage(user.imageUrl.toString()),
            ),
          ),
      unauthenticatedBuilder: (_) => DrawerHeader(
            child: Container(),
          ),
    );
  }
}
