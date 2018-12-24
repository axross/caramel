import 'package:caramel/entities.dart';
import 'package:caramel/models.dart';
import 'package:caramel/model_creators.dart';
import 'package:caramel/widgets.dart';
import 'package:firebase_storage_image/firebase_storage_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendCodeDialog extends StatelessWidget {
  FriendCodeDialog({Key key, @required this.user})
      : assert(user != null),
        super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
            _FriendCodeScanButton(user: user),
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
}

class _FriendCodeScanButton extends StatelessWidget {
  _FriendCodeScanButton({Key key, @required this.user})
      : assert(user != null),
        super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    final newFriendModelCreator = Provider.of<NewFriendModelCreator>(context);

    return _FriendCodeScanButtonInner(
      newFriendModelCreator: newFriendModelCreator,
      user: user,
    );
  }
}

class _FriendCodeScanButtonInner extends StatefulWidget {
  final NewFriendModelCreator newFriendModelCreator;
  final User user;

  _FriendCodeScanButtonInner({
    Key key,
    @required this.newFriendModelCreator,
    @required this.user,
  })  : assert(newFriendModelCreator != null),
        assert(user != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _FriendCodeScanButtonInnerState();
}

class _FriendCodeScanButtonInnerState
    extends State<_FriendCodeScanButtonInner> {
  NewFriendModel _newFriendModel;

  @override
  void initState() {
    super.initState();

    _newFriendModel = widget.newFriendModelCreator.createModel(widget.user);
  }

  @override
  Widget build(BuildContext context) => IconButton(
        icon: Icon(CustomIcons.scan),
        onPressed: () => _newFriendModel.scanRequest.add(null),
      );
}
