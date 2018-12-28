import 'package:caramel/entities.dart';
import 'package:firebase_storage_image/firebase_storage_image.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class FriendList extends StatelessWidget {
  FriendList({Key key, @required this.children})
      : assert(children != null),
        super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 16),
        itemBuilder: (_, index) => children[index],
        separatorBuilder: (_, __) => Divider(),
        itemCount: children.length,
      );
}

class FriendListItem extends StatelessWidget {
  FriendListItem({
    Key key,
    @required this.friendship,
    @required this.onTap,
    @required this.onTapChatButton,
  })  : assert(friendship != null),
        assert(onTap != null),
        assert(onTapChatButton != null),
        super(key: key);

  final Friendship friendship;
  final VoidCallback onTap;
  final VoidCallback onTapChatButton;

  @override
  Widget build(BuildContext context) => FutureBuilder(
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
              trailing: IconButton(
                icon: Icon(Icons.chat_bubble),
                onPressed: onTapChatButton,
              ),
              onTap: onTap,
            ),
      );
}
