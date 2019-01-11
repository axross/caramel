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
              title: const Text('Wind'),
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
