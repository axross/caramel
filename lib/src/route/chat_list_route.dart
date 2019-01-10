import 'package:caramel/domains.dart';
import 'package:flutter/material.dart';
import 'package:caramel/screens.dart';
import 'package:caramel/routes.dart';

class ChatListRoute extends MaterialPageRoute {
  ChatListRoute({
    @required SignedInUser hero,
  }) : super(
          builder: (context) => ChatListScreen(
                hero: hero,
                onRequestNavigateToChat: (chat) => Navigator.of(context).push(
                      ChatRoute(
                        hero: hero,
                        chatId: chat.id,
                      ),
                    ),
              ),
        );
}
