import 'package:caramel/entities.dart';
import 'package:firebase_storage_image/firebase_storage_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatList extends StatelessWidget {
  const ChatList({
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

class ChatListItem extends StatelessWidget {
  const ChatListItem({
    @required this.chat,
    @required this.user,
    @required this.onTap,
    Key key,
  })  : assert(chat != null),
        assert(user != null),
        assert(onTap != null),
        super(key: key);

  final Chat chat;
  final User user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
        title: FutureBuilder<User>(
          future: chat.members
              .firstWhere((member) => !member.isSameUser(user))
              .resolve(),
          builder: (_, snapshot) => snapshot.hasData
              ? Text(snapshot.requireData.name)
              : const Text('Loading...'),
        ),
        subtitle: chat.lastChatMessage == null
            ? const Text('')
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
                          const SizedBox(width: 8),
                          _LastChatMessageTime(
                            lastChatMessage: snapshot.requireData,
                          ),
                        ],
                      )
                    : const Text('Loading...'),
              ),
        leading: CircleAvatar(
          backgroundImage: FirebaseStorageImage(user.imageUrl.toString()),
        ),
        onTap: onTap,
      );
}

class _LastChatMessageTime extends StatelessWidget {
  const _LastChatMessageTime({
    @required this.lastChatMessage,
    Key key,
  })  : assert(lastChatMessage != null),
        super(key: key);

  final ChatMessage lastChatMessage;

  @override
  Widget build(BuildContext context) {
    final difference = DateTime.now().difference(lastChatMessage.sentAt);

    print(difference);

    if (difference.inMinutes < 1) {
      return const Text('Now');
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
  const _LastChatMessageBody({
    @required this.lastChatMessage,
    Key key,
  }) : super(key: key);

  final ChatMessage lastChatMessage;

  @override
  Widget build(BuildContext context) {
    if (lastChatMessage is TextChatMessage) {
      final TextChatMessage lastChatmessageAsTextChatMessage = lastChatMessage;

      return Text(
        lastChatmessageAsTextChatMessage.text,
        overflow: TextOverflow.ellipsis,
      );
    }

    return const Text('');
  }
}
