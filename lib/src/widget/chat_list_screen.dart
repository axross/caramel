import 'package:caramel/domains.dart';
import 'package:caramel/widgets.dart';
import 'package:flutter/material.dart';

class ChatListScreen extends StatelessWidget {
  ChatListScreen({
    @required SignedInUser hero,
    @required StatefulStream<List<Chat>> chats,
    @required ValueChanged<Chat> onRequestNavigateToChat,
    @required VoidCallback onRequestShowFriendCodeDialog,
    Key key,
  })  : assert(hero != null),
        assert(chats != null),
        assert(onRequestNavigateToChat != null),
        assert(onRequestShowFriendCodeDialog != null),
        _hero = hero,
        _chats = chats,
        _onRequestNavigateToChat = onRequestNavigateToChat,
        _onRequestShowFriendCodeDialog = onRequestShowFriendCodeDialog,
        super(key: key);

  final SignedInUser _hero;

  final StatefulStream<List<Chat>> _chats;

  final ValueChanged<Chat> _onRequestNavigateToChat;

  final VoidCallback _onRequestShowFriendCodeDialog;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              textTheme: Theme.of(context).textTheme.apply(
                    bodyColor: Colors.black,
                  ),
              centerTitle: true,
              iconTheme: Theme.of(context).primaryIconTheme.copyWith(
                    color: Colors.black,
                  ),
              elevation: 2,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/icon.png',
                      width: 32,
                      height: 32,
                    ),
                  ),
                  Container(width: 8),
                  Text(
                    'Postman',
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .apply(fontWeightDelta: 2),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(CustomIcons.qr),
                  onPressed: _onRequestShowFriendCodeDialog,
                ),
              ],
            ),
            StreamBuilder<List<Chat>>(
              stream: _chats,
              initialData: _chats.latest,
              builder: (context, chatsSnapshot) => SliverPadding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => i % 2 == 1
                            ? ChatListTile(
                                chat: chatsSnapshot.requireData
                                    .toList()[(i / 2).floor()],
                                hero: _hero,
                                onTapped: () => _onRequestNavigateToChat(
                                    chatsSnapshot.requireData
                                        .toList()[(i / 2).floor()]),
                              )
                            : Container(height: 16),
                        childCount: chatsSnapshot.hasData
                            ? chatsSnapshot.requireData.length * 2 + 1
                            : 0,
                      ),
                    ),
                  ),
            ),
          ],
        ),
      );
}
