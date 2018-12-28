import 'package:caramel/entities.dart';
import 'package:caramel/widgets.dart';
import 'package:firebase_storage_image/firebase_storage_image.dart';
import 'package:flutter/material.dart';

class FriendCodeDialog extends StatelessWidget {
  FriendCodeDialog({
    Key key,
    @required this.user,
    @required this.onScanButtonPressed,
  })  : assert(user != null),
        assert(onScanButtonPressed != null),
        super(key: key);

  final User user;
  final VoidCallback onScanButtonPressed;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Container(
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: FirebaseStorageImage(user.imageUrl.toString()),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(user.name),
              ),
              IconButton(
                icon: Icon(CustomIcons.scan),
                onPressed: onScanButtonPressed,
              ),
            ],
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Scan this to add me to your friends!'),
            SizedBox(
              height: 16,
            ),
            FriendCodeQr(user: user),
          ],
        ),
        actions: [
          FlatButton(
            child: Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
}
