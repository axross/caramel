import 'package:caramel/domains.dart';
import 'package:flutter/material.dart';
import 'package:caramel/screens.dart';
import 'package:caramel/routes.dart';

class HomeRoute extends MaterialPageRoute {
  HomeRoute({
    @required SignedInUser hero,
  }) : super(
          builder: (context) => HomeScreen(
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
