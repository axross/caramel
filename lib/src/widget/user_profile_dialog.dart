import 'package:caramel/domains.dart';
import 'package:firebase_storage_image/firebase_storage_image.dart';
import 'package:flutter/material.dart';

class UserProfileDialog extends StatelessWidget {
  const UserProfileDialog({
    @required this.user,
    Key key,
  })  : assert(user != null),
        super(key: key);

  final UserReference user;

  @override
  Widget build(BuildContext context) => FutureBuilder<User>(
        future: user.resolve,
        initialData: user.value,
        builder: (context, snapshot) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 320,
                    height: 180,
                    decoration: const BoxDecoration(color: Colors.green),
                    child: Stack(
                      children: [
                        Align(
                          alignment: const Alignment(0, 1.8),
                          child: Container(
                            width: 80,
                            height: 80,
                            child: snapshot.hasData
                                ? CircleAvatar(
                                    backgroundImage: FirebaseStorageImage(
                                      snapshot.requireData.imageUrl.toString(),
                                    ),
                                  )
                                : CircleAvatar(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(top: 56, left: 24, right: 24),
                    child: Column(
                      children: [
                        Text(
                            snapshot.hasData
                                ? snapshot.requireData.name
                                : 'Loading...',
                            style: Theme.of(context).textTheme.headline),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              contentPadding: const EdgeInsets.only(bottom: 24),
              actions: [
                FlatButton(
                  child: const Text('Close'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
      );
}
