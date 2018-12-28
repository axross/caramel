import 'package:caramel/entities.dart';
import 'package:firebase_storage_image/firebase_storage_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatList extends StatelessWidget {
  ChatList({Key key, @required this.children})
      : assert(children != null),
        super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 16),
      itemBuilder: (_, index) => children[index],
      separatorBuilder: (_, __) => Divider(),
      itemCount: children.length,
    );
  }
}

class ChatListItem extends StatelessWidget {
  ChatListItem({
    Key key,
    @required this.chat,
    @required this.user,
    @required this.onTap,
  })  : assert(chat != null),
        assert(user != null),
        assert(onTap != null),
        super(key: key);

  final Chat chat;
  final User user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: FutureBuilder<User>(
        future: chat.members
            .firstWhere((member) => !member.isSameUser(user))
            .resolve(),
        builder: (_, snapshot) => snapshot.hasData
            ? Text(snapshot.requireData.name)
            : Text('Loading...'),
      ),
      subtitle: chat.lastChatMessage == null
          ? Text('')
          : FutureBuilder<ChatMessage>(
              future: chat.lastChatMessage.resolve(),
              builder: (_, snapshot) => snapshot.hasData
                  ? Row(
                      children: [
                        Expanded(
                          child: _LastChatMessageBody(
                            lastChatMessage: snapshot.requireData,
                          ),
                        ),
                        SizedBox(width: 8),
                        _LastChatMessageTime(
                          lastChatMessage: snapshot.requireData,
                        ),
                      ],
                    )
                  : Text('Loading...'),
            ),
      leading: CircleAvatar(
        backgroundImage: FirebaseStorageImage(user.imageUrl.toString()),
      ),
      onTap: onTap,
    );
  }
}

class _LastChatMessageTime extends StatelessWidget {
  _LastChatMessageTime({Key key, @required this.lastChatMessage})
      : assert(lastChatMessage != null),
        super(key: key);

  final ChatMessage lastChatMessage;

  @override
  Widget build(BuildContext context) {
    final difference = DateTime.now().difference(lastChatMessage.sentAt);

    print(difference);

    if (difference.inMinutes < 1) {
      return Text('Now');
    }

    if (difference.inHours < 1) {
      return Text('${difference.inMinutes} mins ago');
    }

    if (difference.inHours < 6) {
      return Text('${difference.inHours} hours ago');
    }

    if (difference.inDays < 1) {
      return Text(DateFormat.jm().format(lastChatMessage.sentAt));
    }

    if (difference.inDays < 7) {
      return Text('${difference.inDays} days ago');
    }

    return Text(DateFormat.Md().format(lastChatMessage.sentAt));
  }
}

class _LastChatMessageBody extends StatelessWidget {
  _LastChatMessageBody({Key key, @required this.lastChatMessage})
      : super(key: key);

  final ChatMessage lastChatMessage;

  @override
  Widget build(BuildContext context) {
    if (lastChatMessage is TextChatMessage) {
      return Text(
        (lastChatMessage as TextChatMessage).text,
        overflow: TextOverflow.ellipsis,
      );
    }

    return Text('');
  }
}
