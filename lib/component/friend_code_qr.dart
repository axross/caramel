import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr/qr.dart' show QrErrorCorrectLevel;
import 'package:qr_flutter/qr_flutter.dart';
import '../component/unsafe_authenticated.dart';
import '../entity/friend_code.dart';
import '../entity/user.dart';
import '../model/friend_code_model.dart';
import '../model_creator/friend_code_model_creator.dart';

class FriendCodeQr extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final friendCodeModelCreator = Provider.of<FriendCodeModelCreator>(context);

    return UnsafeAuthenticated(
      builder: (_, user) {
        return _FriendCodeQrInner(
          friendCodeModelCreator: friendCodeModelCreator,
          user: user,
        );
      },
    );
  }
}

class _FriendCodeQrInner extends StatefulWidget {
  final FriendCodeModelCreator friendCodeModelCreator;
  final User user;

  _FriendCodeQrInner({Key key, this.friendCodeModelCreator, this.user})
      : assert(friendCodeModelCreator != null),
        assert(user != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _FriendCodeQrInnerState();
}

class _FriendCodeQrInnerState extends State<_FriendCodeQrInner> {
  FriendCodeModel _friendCodeModel;

  @override
  void initState() {
    super.initState();

    setState(() {
      _friendCodeModel = widget.friendCodeModelCreator.createModel(widget.user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FriendCode>(
      stream: _friendCodeModel.onChanged,
      initialData: _friendCodeModel.friendCode,
      builder: (_, snapshot) => snapshot.hasData
          ? Container(
              width: 192,
              height: 192,
              child: QrImage(
                version: 2,
                errorCorrectionLevel: QrErrorCorrectLevel.M,
                data: snapshot.data.code,
              ),
            )
          : Container(
              width: 192,
              height: 192,
            ),
    );
  }
}
