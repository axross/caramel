import 'package:caramel/entities.dart';
import 'package:firebase_storage_image/firebase_storage_image.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class FriendList extends StatelessWidget {
  const FriendList({
    @required this.children,
    Key key,
  })  : assert(children != null),
        super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemBuilder: (_, index) => children[index],
        separatorBuilder: (_, __) => const Divider(),
        itemCount: children.length,
      );
}

class FriendListItem extends StatelessWidget {
  const FriendListItem({
    @required this.friendship,
    @required this.onTap,
    @required this.onTapChatButton,
    Key key,
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
                  : const Text('Loading...'),
              leading: CircleAvatar(
                backgroundImage: snapshot.hasData
                    ? FirebaseStorageImage(
                        snapshot.data.imageUrl.toString(),
                      )
                    : null,
              ),
              trailing: IconButton(
                icon: const Icon(Icons.chat_bubble),
                onPressed: onTapChatButton,
              ),
              onTap: onTap,
            ),
      );
}
