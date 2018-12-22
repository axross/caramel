import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meta/meta.dart';
import '../entity/friendship.dart';
import '../entity/user.dart';
import '../model/friend_list_model.dart';
import '../model_creator/friend_list_model_creator.dart';
import './firebase_storage_image.dart';

class FriendList extends StatelessWidget {
  final User user;

  FriendList({Key key, @required this.user})
      : assert(user != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final friendListModelCreator = Provider.of<FriendListModelCreator>(context);

    return _FriendListInner(
        user: user, friendListModelCreator: friendListModelCreator);
  }
}

class _FriendListInner extends StatefulWidget {
  final User user;
  final FriendListModelCreator friendListModelCreator;

  _FriendListInner({
    Key key,
    @required this.user,
    @required this.friendListModelCreator,
  })  : assert(user != null),
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

    setState(() {
      _friendListModel = widget.friendListModelCreator.createModel(widget.user);
    });
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<List<Friendship>>(
        stream: _friendListModel.onChanged,
        initialData: _friendListModel.friendships,
        builder: (_, snapshot) => snapshot.hasData
            ? ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 16),
                itemBuilder: (_, index) => FriendListItem(
                    friendship: snapshot.data[index],
                    friendListModel: _friendListModel),
                separatorBuilder: (_, __) => Divider(),
                itemCount: snapshot.data.length,
              )
            : Container(),
      );
}

class FriendListItem extends StatelessWidget {
  final Friendship friendship;
  final FriendListModel friendListModel;

  FriendListItem(
      {Key key, @required this.friendship, @required this.friendListModel})
      : assert(friendship != null),
        assert(friendListModel != null),
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
                      snapshot.data.imageUrl,
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
            onTap: () => print('tapped'),
          ),
    );
  }
}
