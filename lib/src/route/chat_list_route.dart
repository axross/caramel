import 'package:caramel/domains.dart';
import 'package:caramel/routes.dart';
import 'package:caramel/usecases.dart';
import 'package:caramel/widgets.dart';
import 'package:flutter/material.dart';

class ChatListRoute extends MaterialPageRoute {
  ChatListRoute({
    @required SignedInUser hero,
  }) : super(
          builder: (context) {
            final listChats = Provider.of<ChatListUsecase>(context);
            final chats = listChats(hero: hero);

            return ChatListScreen(
              hero: hero,
              chats: chats,
              onRequestNavigateToChat: (chat) => Navigator.of(context).push(
                    ChatRoute(
                      hero: hero,
                      chatId: chat.id,
                    ),
                  ),
              onRequestShowFriendCodeDialog: () => showFriendCodeDialog(
                    context,
                    hero: hero,
                  ),
            );
          },
        );
}
