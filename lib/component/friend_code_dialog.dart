import 'package:firebase_storage_image/firebase_storage_image.dart';
import 'package:flutter/material.dart';
import './friend_code_qr.dart';
import './friend_code_scan_button.dart';
import './unsafe_authenticated.dart';

class FriendCodeDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: UnsafeAuthenticated(
        builder: (_, user) => Container(
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: FirebaseStorageImage(user.imageUrl),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(user.name),
                  ),
                  FriendCodeScanButton(),
                ],
              ),
            ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Scan this to add me to your friends!'),
          SizedBox(
            height: 16,
          ),
          FriendCodeQr(),
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
}
