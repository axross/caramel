import 'package:caramel/domains.dart';
import 'package:caramel/widgets.dart';
import 'package:flutter/material.dart';

class ChatRoute extends MaterialPageRoute {
  ChatRoute({
    @required SignedInUser hero,
    @required String chatId,
  }) : super(
            builder: (context) => ChatScreen(
                  hero: hero,
                  chatId: chatId,
                ));
}
