import 'package:caramel/domains.dart';
import 'package:caramel/usecases.dart';
import 'package:caramel/widgets.dart';
import 'package:firebase_storage_image/firebase_storage_image.dart';
import 'package:flutter/material.dart';

class FriendCodeDialog extends StatelessWidget {
  const FriendCodeDialog({
    @required this.hero,
    Key key,
  })  : assert(hero != null),
        super(key: key);

  final SignedInUser hero;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Container(
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: FirebaseStorageImage(hero.imageUrl.toString()),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(hero.name),
              ),
              _ScanButton(hero: hero),
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
            _FriendCodeQr(hero: hero),
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

class _ScanButton extends StatelessWidget {
  const _ScanButton({@required this.hero, Key key})
      : assert(hero != null),
        super(key: key);

  final SignedInUser hero;

  @override
  Widget build(BuildContext context) {
    final createFriend = Provider.of<FriendCreateUsecase>(context);

    return IconButton(
      icon: const Icon(CustomIcons.scan),
      onPressed: () => createFriend(hero: hero),
    );
  }
}

class _FriendCodeQr extends StatelessWidget {
  const _FriendCodeQr({@required this.hero, Key key})
      : assert(hero != null),
        super(key: key);

  final SignedInUser hero;

  @override
  Widget build(BuildContext context) {
    final getFriendCode = Provider.of<FriendCodeGetUsecase>(context);

    return FriendCodeQr(friendCodeObservable: getFriendCode(hero: hero));
  }
}
