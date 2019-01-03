import 'package:caramel/entities.dart';
import 'package:caramel/models.dart';
import 'package:caramel/model_creators.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr/qr.dart' show QrErrorCorrectLevel;
import 'package:qr_flutter/qr_flutter.dart';

class FriendCodeQr extends StatelessWidget {
  const FriendCodeQr({
    @required this.user,
    Key key,
  })  : assert(user != null),
        super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    final friendCodeModelCreator = Provider.of<FriendCodeModelCreator>(context);

    return _FriendCodeQrInner(
      friendCodeModelCreator: friendCodeModelCreator,
      user: user,
    );
  }
}

class _FriendCodeQrInner extends StatefulWidget {
  const _FriendCodeQrInner({
    @required this.friendCodeModelCreator,
    @required this.user,
    Key key,
  })  : assert(friendCodeModelCreator != null),
        assert(user != null),
        super(key: key);

  final FriendCodeModelCreator friendCodeModelCreator;
  final User user;

  @override
  State<StatefulWidget> createState() => _FriendCodeQrInnerState();
}

class _FriendCodeQrInnerState extends State<_FriendCodeQrInner> {
  FriendCodeModel _friendCodeModel;

  @override
  void initState() {
    super.initState();

    _friendCodeModel = widget.friendCodeModelCreator.createModel(widget.user);
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<FriendCode>(
        stream: _friendCodeModel.onChanged,
        initialData: _friendCodeModel.friendCode,
        builder: (_, snapshot) => snapshot.hasData
            ? Container(
                width: 192,
                height: 192,
                child: QrImage(
                  version: 2,
                  errorCorrectionLevel: QrErrorCorrectLevel.M,
                  data: snapshot.data.data,
                ),
              )
            : Container(
                width: 192,
                height: 192,
              ),
      );
}
