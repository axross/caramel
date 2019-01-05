import 'package:caramel/domains.dart';
import 'package:firebase_storage_image/firebase_storage_image.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class FriendList extends StatelessWidget {
  FriendList({
    @required this.friendshipsObservable,
    @required this.onFriendTapped,
    @required this.onChatTapped,
    Key key,
  })  : assert(friendshipsObservable != null),
        assert(onFriendTapped != null),
        assert(onChatTapped != null),
        super(key: key);

  final FriendshipsObservable friendshipsObservable;

  final ValueChanged<Friendship> onFriendTapped;

  final ValueChanged<Chat> onChatTapped;

  @override
  Widget build(BuildContext context) => StreamBuilder<List<Friendship>>(
        stream: friendshipsObservable.onChanged
            .map((friendships) => friendships.toList()),
        initialData: friendshipsObservable.latest?.toList(),
        builder: (context, friendListSnapshot) => friendListSnapshot.hasData
            ? ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemBuilder: (context, index) => _FriendListItem(
                      friendship: friendListSnapshot.requireData[index],
                      onTap: () =>
                          onFriendTapped(friendListSnapshot.requireData[index]),
                      onChatTapped: onChatTapped,
                    ),
                separatorBuilder: (context, index) => const Divider(),
                itemCount: friendListSnapshot.requireData.length,
              )
            : ListView(),
      );
}

class _FriendListItem extends StatelessWidget {
  const _FriendListItem({
    @required this.friendship,
    @required this.onTap,
    @required this.onChatTapped,
    Key key,
  })  : assert(friendship != null),
        assert(onTap != null),
        assert(onChatTapped != null),
        super(key: key);

  final Friendship friendship;
  final VoidCallback onTap;
  final ValueChanged<Chat> onChatTapped;

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: friendship.user.resolve,
        initialData: friendship.user.value,
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
              trailing: FutureBuilder(
                future: friendship.oneOnOneChat.resolve,
                initialData: friendship.oneOnOneChat.value,
                builder: (_, oneOnOneChatSnapshot) =>
                    oneOnOneChatSnapshot.hasData
                        ? IconButton(
                            icon: const Icon(Icons.chat_bubble),
                            onPressed: () =>
                                onChatTapped(oneOnOneChatSnapshot.requireData),
                          )
                        : Container(width: 0, height: 0),
              ),
              onTap: onTap,
            ),
      );
}
