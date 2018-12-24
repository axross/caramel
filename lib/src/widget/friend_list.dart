import 'package:caramel/entity.dart';
import 'package:caramel/model.dart';
import 'package:caramel/model_creator.dart';
import 'package:firebase_storage_image/firebase_storage_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meta/meta.dart';

class FriendList extends StatelessWidget {
  FriendList({Key key, @required this.user, @required this.onItemTapped})
      : assert(user != null),
        assert(onItemTapped != null),
        super(key: key);

  final User user;
  final FriendShipCallback onItemTapped;

  @override
  Widget build(BuildContext context) {
    final friendListModelCreator = Provider.of<FriendListModelCreator>(context);

    return _FriendListInner(
        user: user,
        onItemTapped: onItemTapped,
        friendListModelCreator: friendListModelCreator);
  }
}

typedef void FriendShipCallback(Friendship friendship);

class _FriendListInner extends StatefulWidget {
  final User user;
  final FriendShipCallback onItemTapped;
  final FriendListModelCreator friendListModelCreator;

  _FriendListInner({
    Key key,
    @required this.user,
    @required this.onItemTapped,
    @required this.friendListModelCreator,
  })  : assert(user != null),
        assert(onItemTapped != null),
        assert(friendListModelCreator != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _FriendListInnerState();
}

class _FriendListInnerState extends State<_FriendListInner> {
  FriendListModel _friendListModel;

  @override
  void initState() {
    super.initState();

    _friendListModel = widget.friendListModelCreator.createModel(widget.user);
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<List<Friendship>>(
        stream: _friendListModel.onChanged,
        initialData: _friendListModel.friendships,
        builder: (_, snapshot) => snapshot.hasData
            ? ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 16),
                itemBuilder: (_, index) => _FriendListItem(
                      friendship: snapshot.data[index],
                      friendListModel: _friendListModel,
                      onTap: () => widget.onItemTapped(snapshot.data[index]),
                    ),
                separatorBuilder: (_, __) => Divider(),
                itemCount: snapshot.data.length,
              )
            : Container(),
      );
}

class _FriendListItem extends StatelessWidget {
  final Friendship friendship;
  final FriendListModel friendListModel;
  final VoidCallback onTap;

  _FriendListItem({
    Key key,
    @required this.friendship,
    @required this.friendListModel,
    @required this.onTap,
  })  : assert(friendship != null),
        assert(friendListModel != null),
        assert(onTap != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: friendship.user.resolve(),
      builder: (_, snapshot) => ListTile(
            title: snapshot.hasData
                ? Text(snapshot.data.name)
                : Text('Loading...'),
            leading: CircleAvatar(
              backgroundImage: snapshot.hasData
                  ? FirebaseStorageImage(
                      snapshot.data.imageUrl.toString(),
                    )
                  : null,
            ),
            trailing: PopupMenuButton(
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'A',
                      child: Text('Delete'),
                    ),
                  ],
              onSelected: (value) {
                if (value == 'A') {
                  friendListModel.deletion.add(friendship);
                }
              },
            ),
            onTap: onTap,
          ),
    );
  }
}
