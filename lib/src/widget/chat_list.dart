import 'package:caramel/domains.dart';
import 'package:firebase_storage_image/firebase_storage_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatList extends StatelessWidget {
  ChatList({
    @required this.hero,
    @required this.chatsObervable,
    @required this.onChatTapped,
    Key key,
  })  : assert(hero != null),
        assert(chatsObervable != null),
        assert(onChatTapped != null),
        super(key: key);

  final SignedInUser hero;

  final ChatsObservable chatsObervable;

  final ValueChanged<Chat> onChatTapped;

  @override
  Widget build(BuildContext context) => StreamBuilder<List<Chat>>(
        stream: chatsObervable.onChanged.map((chats) => chats.toList()),
        initialData: chatsObervable.latest?.toList(),
        builder: (context, myChatsSnapshot) => StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 5)),
              builder: (context, _) => ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemBuilder: (_, index) => myChatsSnapshot.hasData
                        ? _ChatListItem(
                            hero: hero,
                            chat: myChatsSnapshot.requireData[index],
                            onTapped: () => onChatTapped(
                                  myChatsSnapshot.requireData[index],
                                ),
                          )
                        : null,
                    separatorBuilder: (_, __) => const Divider(),
                    itemCount: myChatsSnapshot.hasData
                        ? myChatsSnapshot.requireData.length
                        : 0,
                  ),
            ),
      );
}

class _ChatListItem extends StatelessWidget {
  const _ChatListItem({
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
        title: FutureBuilder<Iterable<User>>(
          future: chat.participants.resolve,
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
        leading: FutureBuilder<Iterable<User>>(
          future: chat.participants.resolve,
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
