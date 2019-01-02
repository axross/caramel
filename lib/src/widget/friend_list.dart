import 'package:caramel/entities.dart';
import 'package:caramel/model_creators.dart';
import 'package:caramel/models.dart';
import 'package:caramel/screens.dart';
import 'package:firebase_storage_image/firebase_storage_image.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';

class FriendList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authenticationModel = Provider.of<AuthenticationModel>(context);
    final friendListModel = Provider.of<FriendListModel>(context);
    final chatByFriendshipModelCreator =
        Provider.of<ChatByFriendshipModelCreator>(context);

    return StreamBuilder<User>(
      stream: authenticationModel.onUserChanged,
      initialData: authenticationModel.user,
      builder: (context, authenticationSnapshot) =>
          StreamBuilder<List<Friendship>>(
            stream: friendListModel.onChanged.map(
              (friendships) => friendships.toList(),
            ),
            initialData: friendListModel.friendships.toList(),
            builder: (context, friendListSnapshot) => friendListSnapshot.hasData
                ? ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemBuilder: (context, index) {
                      final friendship = friendListSnapshot.requireData[index];

                      return StatefulProvider<ChatByFriendshipModel>(
                        valueBuilder: (context, old) =>
                            old ??
                            chatByFriendshipModelCreator.createModel(
                              user: authenticationSnapshot.requireData,
                              friendship: friendship,
                            ),
                        child: _FriendListItem(
                          friendship: friendship,
                          onTap: () {},
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: friendListSnapshot.requireData.length,
                  )
                : ListView(),
          ),
    );
  }
}

class _FriendListItem extends StatelessWidget {
  const _FriendListItem({
    @required this.friendship,
    @required this.onTap,
    Key key,
  })  : assert(friendship != null),
        assert(onTap != null),
        super(key: key);

  final Friendship friendship;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final chatByFriendshipModel = Provider.of<ChatByFriendshipModel>(context);

    return FutureBuilder(
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
            trailing: StreamBuilder<Chat>(
              stream: chatByFriendshipModel.onChanged,
              initialData: chatByFriendshipModel.chat,
              builder: (
                context,
                chatByFriendshipSnapshot,
              ) =>
                  chatByFriendshipSnapshot.hasData
                      ? IconButton(
                          icon: const Icon(Icons.chat_bubble),
                          onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ChatMessageListScreen(
                                        chatReference: chatByFriendshipSnapshot
                                            .requireData
                                            .toReference(),
                                      ),
                                ),
                              ),
                        )
                      : Container(width: 0, height: 0),
            ),
            onTap: onTap,
          ),
    );
  }
}
