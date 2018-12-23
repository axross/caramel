import 'package:firebase_storage_image/firebase_storage_image.dart';
import 'package:flutter/material.dart';
import '../entity/user.dart';
import '../entity/user_reference.dart';

class CircleAvatarByUserReference extends StatelessWidget {
  final UserReference userReference;

  CircleAvatarByUserReference({Key key, @required this.userReference})
      : assert(userReference != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: userReference.resolve(),
      builder: (_, snapshot) => snapshot.hasData
          ? CircleAvatar(
              backgroundImage:
                  FirebaseStorageImage(snapshot.requireData.imageUrl),
            )
          : CircleAvatar(),
    );
  }
}
