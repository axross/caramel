import 'package:caramel/domains.dart';
import 'package:caramel/usecases.dart';
import 'package:caramel/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({
    @required SignedInUser hero,
    @required ValueChanged<Chat> onRequestNavigateToChat,
    Key key,
  })  : assert(hero != null),
        assert(onRequestNavigateToChat != null),
        _hero = hero,
        _onRequestNavigateToChat = onRequestNavigateToChat,
        super(key: key);

  final SignedInUser _hero;

  final ValueChanged<Chat> _onRequestNavigateToChat;

  @override
  Widget build(BuildContext context) {
    final listFriends = Provider.of<FriendListUsecase>(context);
    final listChats = Provider.of<ChatListUsecase>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Friends'),
          actions: [
            IconButton(
              icon: const Icon(CustomIcons.qr),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => FriendCodeDialog(hero: _hero),
                );
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.face),
                text: 'Friends',
              ),
              Tab(
                icon: Icon(Icons.chat),
                text: 'Chats',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FriendList(
              friendshipsObservable: listFriends(
                hero: _hero,
              ),
              onChatTapped: _onRequestNavigateToChat,
            ),
            ChatList(
              hero: _hero,
              chatsObervable: listChats(hero: _hero),
              onChatTapped: _onRequestNavigateToChat,
            ),
          ],
        ),
      ),
    );
  }
}
