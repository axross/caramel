import 'package:caramel/domains.dart';
import 'package:flutter/material.dart';
import 'package:qr/qr.dart' show QrErrorCorrectLevel;
import 'package:qr_flutter/qr_flutter.dart';

class FriendCodeQr extends StatelessWidget {
  const FriendCodeQr({
    @required this.friendCodeObservable,
    Key key,
  })  : assert(friendCodeObservable != null),
        super(key: key);

  final FriendCodeObservable friendCodeObservable;

  @override
  Widget build(BuildContext context) => StreamBuilder<FriendCode>(
        stream: friendCodeObservable.onChanged,
        initialData: friendCodeObservable.latest,
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
