import 'package:caramel/domains.dart';
import 'package:caramel/usecases.dart';
import 'package:caramel/widgets.dart';
import 'package:flutter/material.dart';

Future<dynamic> showFriendCodeDialog(
  BuildContext context, {
  @required SignedInUser hero,
}) {
  final getFriendCode = Provider.of<FriendCodeGetUsecase>(context);
  final createFriendship = Provider.of<FriendshipCreateUsecase>(context);
  final friendCode = getFriendCode(hero: hero);

  showDialog(
    context: context,
    builder: (context) => FriendCodeDialog(
          hero: hero,
          friendCode: friendCode,
          createFriendship: createFriendship,
        ),
  );
}
