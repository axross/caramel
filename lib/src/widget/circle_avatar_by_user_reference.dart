import 'package:caramel/entities.dart';
import 'package:firebase_storage_image/firebase_storage_image.dart';
import 'package:flutter/material.dart';

class CircleAvatarByUserReference extends StatelessWidget {
  CircleAvatarByUserReference({Key key, @required this.userReference})
      : assert(userReference != null),
        super(key: key);

  final UserReference userReference;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: userReference.resolve(),
      builder: (_, snapshot) => snapshot.hasData
          ? CircleAvatar(
              backgroundImage: FirebaseStorageImage(
                  snapshot.requireData.imageUrl.toString()),
            )
          : CircleAvatar(),
    );
  }
}
