import 'package:caramel/domains.dart';
import 'package:firebase_storage_image/firebase_storage_image.dart';
import 'package:flutter/material.dart';

class ChatMessageList extends StatelessWidget {
  const ChatMessageList({
    @required this.hero,
    @required this.chatMessages,
    Key key,
  })  : assert(hero != null),
        assert(chatMessages != null),
        super(key: key);

  final SignedInUser hero;

  final StatefulStream<List<ChatMessage>> chatMessages;

  @override
  Widget build(BuildContext context) => StreamBuilder<List<ChatMessage>>(
        stream:
            chatMessages.map((chatMessages) => chatMessages.reversed.toList()),
        initialData: chatMessages.latest?.reversed?.toList(),
        builder: (_, snapshot) => ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              reverse: true,
              itemBuilder: snapshot.hasData
                  ? (_, index) {
                      final chatMessage = snapshot.requireData[index];
                      final previousChatMessage =
                          index == snapshot.requireData.length - 1
                              ? null
                              : snapshot.requireData[index + 1];
                      final nextChatMessage =
                          index == 0 ? null : snapshot.requireData[index - 1];

                      return _ChatMessageListItem(
                        hero: hero,
                        chatMessage: chatMessage,
                        previousChatMessage: previousChatMessage,
                        nextChatMessage: nextChatMessage,
                      );
                    }
                  : (_, __) => Container(),
              itemCount: snapshot.hasData ? snapshot.requireData.length : 0,
            ),
      );
}

class _ChatMessageListItem extends StatelessWidget {
  const _ChatMessageListItem({
    @required this.hero,
    @required this.chatMessage,
    @required this.previousChatMessage,
    @required this.nextChatMessage,
    Key key,
  })  : assert(hero != null),
        assert(chatMessage != null),
        super(key: key);

  final SignedInUser hero;

  final ChatMessage chatMessage;

  final ChatMessage previousChatMessage;

  final ChatMessage nextChatMessage;

  @override
  Widget build(BuildContext context) => Container(
        margin: chatMessage.sender != previousChatMessage?.sender
            ? const EdgeInsets.only(top: 16)
            : const EdgeInsets.only(top: 4),
        child: Row(
          children: hero.isSameWithReference(chatMessage.sender)
              ? [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.15 + 40,
                  ),
                  Expanded(
                    child: _ChatMessageContent(
                      hero: hero,
                      chatMessage: chatMessage,
                      previousChatMessage: previousChatMessage,
                      nextChatMessage: nextChatMessage,
                    ),
                  ),
                ]
              : [
                  chatMessage.sender == previousChatMessage?.sender
                      ? const SizedBox(width: 40)
                      : FutureBuilder<User>(
                          future: chatMessage.sender.resolve,
                          initialData: chatMessage.sender.value,
                          builder: (_, snapshot) => snapshot.hasData
                              ? CircleAvatar(
                                  backgroundImage: FirebaseStorageImage(
                                    snapshot.requireData.imageUrl.toString(),
                                  ),
                                )
                              : const CircleAvatar(),
                        ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ChatMessageContent(
                      hero: hero,
                      chatMessage: chatMessage,
                      previousChatMessage: previousChatMessage,
                      nextChatMessage: nextChatMessage,
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                ],
        ),
      );
}

class _ChatMessageContent extends StatelessWidget {
  const _ChatMessageContent({
    @required this.hero,
    @required this.chatMessage,
    @required this.previousChatMessage,
    @required this.nextChatMessage,
    Key key,
  })  : assert(hero != null),
        assert(chatMessage != null),
        super(key: key);

  final SignedInUser hero;
  final ChatMessage chatMessage;
  final ChatMessage previousChatMessage;
  final ChatMessage nextChatMessage;

  @override
  Widget build(BuildContext context) {
    if (chatMessage is TextChatMessage) {
      return _TextChatMessageContent(
        hero: hero,
        chatMessage: chatMessage,
        previousChatMessage: previousChatMessage,
        nextChatMessage: nextChatMessage,
      );
    }

    return null;
  }
}

class _TextChatMessageContent extends StatelessWidget {
  const _TextChatMessageContent({
    @required this.hero,
    @required this.chatMessage,
    @required this.previousChatMessage,
    @required this.nextChatMessage,
    Key key,
  })  : assert(hero != null),
        assert(chatMessage != null),
        super(key: key);

  final SignedInUser hero;
  final TextChatMessage chatMessage;
  final ChatMessage previousChatMessage;
  final ChatMessage nextChatMessage;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: hero.isSameWithReference(chatMessage.sender)
              ? Colors.white
              : Theme.of(context).accentColor,
          borderRadius: BorderRadius.vertical(
            top: chatMessage.sender != previousChatMessage?.sender
                ? const Radius.circular(16)
                : const Radius.circular(4),
            bottom: chatMessage.sender != nextChatMessage?.sender
                ? const Radius.circular(16)
                : const Radius.circular(4),
          ),
        ),
        child: Text(
          chatMessage.body,
          style: TextStyle(
            color: hero.isSameWithReference(chatMessage.sender)
                ? Theme.of(context).textTheme.body1.color
                : Theme.of(context).accentTextTheme.body1.color,
            height: 1.333,
          ),
        ),
      );
}
