import 'package:caramel/entities.dart';
import 'package:caramel/widgets.dart';
import 'package:firebase_storage_image/firebase_storage_image.dart';
import 'package:flutter/material.dart';

class FriendCodeDialog extends StatelessWidget {
  const FriendCodeDialog({
    @required this.user,
    @required this.onScanButtonPressed,
    Key key,
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
              const SizedBox(width: 16),
              Expanded(
                child: Text(user.name),
              ),
              IconButton(
                icon: const Icon(CustomIcons.scan),
                onPressed: onScanButtonPressed,
              ),
            ],
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Scan this to add me to your friends!'),
            const SizedBox(
              height: 16,
            ),
            FriendCodeQr(user: user),
          ],
        ),
        actions: [
          FlatButton(
            child: const Text('Close'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
}
