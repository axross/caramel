import 'package:caramel/entities.dart';
import 'package:caramel/models.dart';
import 'package:caramel/model_creators.dart';
import 'package:caramel/screens.dart';
import 'package:caramel/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final friendListModelCreator = Provider.of<FriendListModelCreator>(context);
    final newFriendModelCreator = Provider.of<NewFriendModelCreator>(context);
    final chatListModelCreator = Provider.of<ChatListModelCreator>(context);
    final chatByFriendshipModelCreator =
        Provider.of<ChatByFriendshipModelCreator>(context);

    return Authenticated(
      authenticatedBuilder: (_, user) => _FriendListScreenInner(
            friendListModelCreator: friendListModelCreator,
            newFriendModelCreator: newFriendModelCreator,
            chatListModelCreator: chatListModelCreator,
            chatByFriendshipModelCreator: chatByFriendshipModelCreator,
            user: user,
          ),
      unauthenticatedBuilder: (_) => Container(),
    );
  }
}

class _FriendListScreenInner extends StatefulWidget {
  const _FriendListScreenInner({
    @required this.friendListModelCreator,
    @required this.newFriendModelCreator,
    @required this.chatListModelCreator,
    @required this.chatByFriendshipModelCreator,
    @required this.user,
    Key key,
  })  : assert(friendListModelCreator != null),
        assert(newFriendModelCreator != null),
        assert(chatListModelCreator != null),
        assert(chatByFriendshipModelCreator != null),
        assert(user != null),
        super(key: key);

  final FriendListModelCreator friendListModelCreator;
  final NewFriendModelCreator newFriendModelCreator;
  final ChatListModelCreator chatListModelCreator;
  final ChatByFriendshipModelCreator chatByFriendshipModelCreator;
  final User user;

  @override
  State<StatefulWidget> createState() => _FriendListScreenInnerState();
}

class _FriendListScreenInnerState extends State<_FriendListScreenInner> {
  FriendListModel _friendListModel;
  NewFriendModel _newFriendModel;
  ChatListModel _chatListModel;

  @override
  void initState() {
    super.initState();

    _friendListModel = widget.friendListModelCreator.createModel(widget.user);
    _newFriendModel = widget.newFriendModelCreator.createModel(widget.user);
    _chatListModel = widget.chatListModelCreator.createModel(user: widget.user);
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
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
                    builder: (_) => FriendCodeDialog(
                          user: widget.user,
                          onScanButtonPressed: () =>
                              _newFriendModel.scanRequest.add(null),
                        ),
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
          drawer: Drawer(
            child: ListView(
              children: [
                UserDrawerHeader(),
                ListTile(
                  title: const Text('Item 1'),
                  onTap: () {
                    print('item 1');
                  },
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Provider(
                value: _friendListModel,
                child: FriendList(),
              ),
              StreamBuilder<Iterable<Chat>>(
                stream: _chatListModel.onChanged,
                initialData: _chatListModel.chats,
                builder: (_, snapshot) => StreamBuilder(
                      stream: Stream.periodic(Duration(minutes: 1)),
                      builder: (_, __) => ChatList(
                            children: snapshot.requireData
                                .map(
                                  (chat) => ChatListItem(
                                        chat: chat,
                                        user: widget.user,
                                        onTap: () => Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    ChatMessageListScreen(
                                                        chatReference:
                                                            chat.toReference()),
                                              ),
                                            ),
                                      ),
                                )
                                .toList(),
                          ),
                    ),
              ),
            ],
          ),
        ),
      );
}
