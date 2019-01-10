import 'package:caramel/domains.dart';
import 'package:caramel/usecases.dart';
import 'package:caramel/widgets.dart';
import 'package:flutter/material.dart';

class ChatListScreen extends StatelessWidget {
  ChatListScreen({
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
    final listChats = Provider.of<ChatListUsecase>(context);

    return MemoizedBuilder(
      valueBuilder: (context, old) => old ?? listChats(hero: _hero),
      builder: (context, chatsObservable) => Scaffold(
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
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => FriendCodeDialog(hero: _hero),
                        );
                      },
                    ),
                  ],
                ),
                StreamBuilder<Iterable<Chat>>(
                  stream: chatsObservable.onChanged,
                  initialData: chatsObservable.latest,
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
          ),
    );
  }
}
