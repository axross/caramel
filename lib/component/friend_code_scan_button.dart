import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../entity/user.dart';
import '../model/new_friend_model.dart';
import '../model_creator/new_friend_model_creator.dart';
import './unsafe_authenticated.dart';

class FriendCodeScanButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => UnsafeAuthenticated(
        builder: (context, user) {
          final newFriendModelCreator =
              Provider.of<NewFriendModelCreator>(context);

          return _FriendCodeScanButtonInner(
            newFriendModelCreator: newFriendModelCreator,
            user: user,
          );
        },
      );
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

    setState(() {
      _newFriendModel = widget.newFriendModelCreator.createModel(widget.user);
    });
  }

  @override
  Widget build(BuildContext context) => IconButton(
        icon: Icon(Icons.accessible),
        onPressed: () => _newFriendModel.scanRequest.add(null),
      );
}
