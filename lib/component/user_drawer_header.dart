import 'package:flutter/material.dart';
import './authenticated.dart';
import './firebase_storage_image.dart';

class UserDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Authenticated(
      authenticatedBuilder: (_, user) => UserAccountsDrawerHeader(
            accountName: Text(user.name),
            accountEmail: Text(user.uid),
            currentAccountPicture: CircleAvatar(
              backgroundImage: FirebaseStorageImage(user.imageUrl),
            ),
          ),
      unauthenticatedBuilder: (_) => DrawerHeader(
            child: Container(),
          ),
    );
  }
}
