import 'package:caramel/domains.dart';
import 'package:caramel/usecases.dart';
import 'package:caramel/widgets.dart';
import 'package:firebase_storage_image/firebase_storage_image.dart';
import 'package:flutter/material.dart';

class FriendCodeDialog extends StatelessWidget {
  const FriendCodeDialog({
    @required this.hero,
    @required this.friendCode,
    @required this.createFriend,
    Key key,
  })  : assert(hero != null),
        assert(friendCode != null),
        super(key: key);

  final SignedInUser hero;

  final StatefulStream<FriendCode> friendCode;

  final FriendCreateUsecase createFriend;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: AlertDialog(
          title: Container(
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      FirebaseStorageImage(hero.imageUrl.toString()),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(hero.name),
                ),
                _ScanButton(
                  hero: hero,
                  createFriend: createFriend,
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
              _FriendCodeQr(friendCode: friendCode),
            ],
          ),
          actions: [
            FlatButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
}

class _ScanButton extends StatelessWidget {
  const _ScanButton({
    @required this.hero,
    @required this.createFriend,
    Key key,
  })  : assert(hero != null),
        assert(createFriend != null),
        super(key: key);

  final SignedInUser hero;

  final FriendCreateUsecase createFriend;

  @override
  Widget build(BuildContext context) => IconButton(
        icon: const Icon(CustomIcons.scan),
        onPressed: () async {
          try {
            await createFriend();
          } on InvalidFriendCodeScanned {
            return Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('The scanned QR code is invalid. Try again.'),
              ),
            );
          } on AlreadyFriend {
            return Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('You are already friends.'),
              ),
            );
          } on ServerInternalException {
            return Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('Server error. Try again later.'),
              ),
            );
          }
        },
      );
}

class _FriendCodeQr extends StatelessWidget {
  const _FriendCodeQr({
    @required this.friendCode,
    Key key,
  })  : assert(friendCode != null),
        super(key: key);

  final StatefulStream<FriendCode> friendCode;

  @override
  Widget build(BuildContext context) => FriendCodeQr(friendCode: friendCode);
}
