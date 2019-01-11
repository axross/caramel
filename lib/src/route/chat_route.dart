import 'package:caramel/domains.dart';
import 'package:caramel/usecases.dart';
import 'package:caramel/widgets.dart';
import 'package:flutter/material.dart';

class ChatRoute extends MaterialPageRoute {
  ChatRoute({
    @required SignedInUser hero,
    @required String chatId,
  }) : super(
          builder: (context) {
            final participateChat =
                Provider.of<ChatParticipateUsecase>(context);

            final chatParticipation = participateChat(
              hero: hero,
              chatId: chatId,
            );

            return ChatScreen(chatParticipation: chatParticipation);
          },
        );
}
