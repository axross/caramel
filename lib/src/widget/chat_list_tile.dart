import 'package:caramel/domains.dart';
import 'package:firebase_storage_image/firebase_storage_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatListTile extends StatelessWidget {
  const ChatListTile({
    @required this.chat,
    @required this.hero,
    @required this.onTapped,
    Key key,
  })  : assert(chat != null),
        assert(hero != null),
        assert(onTapped != null),
        super(key: key);

  final SignedInUser hero;

  final Chat chat;

  final VoidCallback onTapped;

  @override
  Widget build(BuildContext context) => ListTile(
        title: FutureBuilder<List<User>>(
          future: chat.participants,
          initialData: chat.participants.value,
          builder: (_, snapshot) => snapshot.hasData
              ? Text(
                  snapshot.requireData.firstWhere((user) => user != hero).name,
                )
              : const Text('Loading...'),
        ),
        subtitle: chat.lastChatMessage == null
            ? const Text('')
            : FutureBuilder<ChatMessage>(
                future: chat.lastChatMessage.resolve,
                initialData: chat.lastChatMessage.value,
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
        leading: FutureBuilder<List<User>>(
          future: chat.participants,
          initialData: chat.participants.value,
          builder: (_, snapshot) => snapshot.hasData
              ? CircleAvatar(
                  backgroundImage: FirebaseStorageImage(snapshot.requireData
                      .firstWhere((user) => user != hero)
                      .imageUrl
                      .toString()),
                )
              : CircleAvatar(
                  child: Image.asset('assets/images/avatar-loading.gif'),
                ),
        ),
        onTap: onTapped,
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

    if (difference.inSeconds < 15) {
      return const Text('Now');
    }

    if (difference.inMinutes < 1) {
      return Text('${difference.inSeconds} seconds ago');
    }

    if (difference.inHours < 1) {
      return Text('${difference.inMinutes} minutes ago');
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
        lastChatmessageAsTextChatMessage.body,
        overflow: TextOverflow.ellipsis,
      );
    }

    return const Text('');
  }
}
