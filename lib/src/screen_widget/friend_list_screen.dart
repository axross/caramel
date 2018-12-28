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
  _FriendListScreenInner({
    Key key,
    @required this.friendListModelCreator,
    @required this.newFriendModelCreator,
    @required this.chatListModelCreator,
    @required this.chatByFriendshipModelCreator,
    @required this.user,
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
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Friends'),
          actions: [
            IconButton(
              icon: Icon(CustomIcons.qr),
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
          bottom: TabBar(
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
                title: Text('Item 1'),
                onTap: () {
                  print('item 1');
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StreamBuilder<Iterable<Friendship>>(
              stream: _friendListModel.onChanged,
              initialData: _friendListModel.friendships,
              builder: (_, snapshot) => snapshot.hasData
                  ? FriendList(
                      children: snapshot.requireData
                          .map(
                            (friendship) => _FriendListItem(
                                  key: ValueKey(friendship),
                                  friendship: friendship,
                                  user: widget.user,
                                  chatByFriendshipModelCreator:
                                      widget.chatByFriendshipModelCreator,
                                  friendListModel: _friendListModel,
                                ),
                          )
                          .toList(),
                    )
                  : Container(),
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
}

class _FriendListItem extends StatefulWidget {
  _FriendListItem({
    Key key,
    @required this.friendship,
    @required this.user,
    @required this.chatByFriendshipModelCreator,
    @required this.friendListModel,
  })  : assert(friendship != null),
        assert(user != null),
        assert(chatByFriendshipModelCreator != null),
        assert(friendListModel != null),
        super(key: key);

  final Friendship friendship;
  final User user;
  final ChatByFriendshipModelCreator chatByFriendshipModelCreator;
  final FriendListModel friendListModel;

  @override
  State<StatefulWidget> createState() => _FriendListItemState();
}

class _FriendListItemState extends State<_FriendListItem> {
  ChatByFriendshipModel _chatByFriendshipModel;

  @override
  void initState() {
    super.initState();

    _chatByFriendshipModel = widget.chatByFriendshipModelCreator.createModel(
      user: widget.user,
      friendship: widget.friendship,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Chat>(
      stream: _chatByFriendshipModel.onChanged,
      initialData: _chatByFriendshipModel.chat,
      builder: (_, snapshot) => snapshot.hasData
          ? FriendListItem(
              friendship: widget.friendship,
              onTap: () {},
              // onTapDeleteButton: () =>
              //     widget.friendListModel.deletion.add(widget.friendship),
              onTapChatButton: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ChatMessageListScreen(
                          chatReference: snapshot.requireData.toReference()),
                    ),
                  ),
            )
          : Container(),
    );
  }
}
