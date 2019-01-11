import 'package:caramel/domains.dart';
import 'package:flutter/material.dart';
import 'package:qr/qr.dart' show QrErrorCorrectLevel;
import 'package:qr_flutter/qr_flutter.dart';

class FriendCodeQr extends StatelessWidget {
  const FriendCodeQr({
    @required this.friendCode,
    Key key,
  })  : assert(friendCode != null),
        super(key: key);

  final StatefulStream<FriendCode> friendCode;

  @override
  Widget build(BuildContext context) => StreamBuilder<FriendCode>(
        stream: friendCode,
        initialData: friendCode.latest,
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
