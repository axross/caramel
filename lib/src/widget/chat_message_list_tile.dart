import 'package:caramel/domains.dart';
import 'package:firebase_storage_image/firebase_storage_image.dart';
import 'package:flutter/material.dart';

class ChatMessageListTile extends StatelessWidget {
  const ChatMessageListTile({
    @required this.hero,
    @required this.chatMessage,
    @required this.aboveChatMessage,
    @required this.belowChatMessage,
    Key key,
  })  : assert(hero != null),
        assert(chatMessage != null),
        super(key: key);

  final SignedInUser hero;

  final ChatMessage chatMessage;

  final ChatMessage aboveChatMessage;

  final ChatMessage belowChatMessage;

  @override
  Widget build(BuildContext context) => Container(
        margin: aboveChatMessage == null
            ? null
            : chatMessage.sender == aboveChatMessage.sender
                ? const EdgeInsets.only(top: 2)
                : const EdgeInsets.only(top: 12),
        child: Row(
          children: chatMessage.sender.isSameWithUser(hero)
              ? [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.15 + 40,
                  ),
                  Expanded(
                    child: _ChatMessageContent(
                      hero: hero,
                      chatMessage: chatMessage,
                      aboveChatMessage: aboveChatMessage,
                      belowChatMessage: belowChatMessage,
                    ),
                  ),
                ]
              : [
                  chatMessage.sender == aboveChatMessage?.sender
                      ? const SizedBox(width: 40)
                      : FutureBuilder<User>(
                          future: chatMessage.sender,
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
                      aboveChatMessage: aboveChatMessage,
                      belowChatMessage: belowChatMessage,
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
    @required this.aboveChatMessage,
    @required this.belowChatMessage,
    Key key,
  })  : assert(hero != null),
        assert(chatMessage != null),
        super(key: key);

  final SignedInUser hero;
  final ChatMessage chatMessage;
  final ChatMessage aboveChatMessage;
  final ChatMessage belowChatMessage;

  @override
  Widget build(BuildContext context) {
    if (chatMessage is TextChatMessage) {
      return _TextChatMessageContent(
        hero: hero,
        chatMessage: chatMessage,
        aboveChatMessage: aboveChatMessage,
        belowChatMessage: belowChatMessage,
      );
    }

    return null;
  }
}

class _TextChatMessageContent extends StatelessWidget {
  const _TextChatMessageContent({
    @required this.hero,
    @required this.chatMessage,
    @required this.aboveChatMessage,
    @required this.belowChatMessage,
    Key key,
  })  : assert(hero != null),
        assert(chatMessage != null),
        super(key: key);

  final SignedInUser hero;
  final TextChatMessage chatMessage;
  final ChatMessage aboveChatMessage;
  final ChatMessage belowChatMessage;

  @override
  Widget build(BuildContext context) {
    final isMine = chatMessage.sender.isSameWithUser(hero);
    final isAboveMine = chatMessage.sender == aboveChatMessage?.sender;
    final isBelowMine = chatMessage.sender == belowChatMessage?.sender;
    final borderRadius = BorderRadius.only(
      topLeft: isMine
          ? Radius.circular(20)
          : isAboveMine ? Radius.circular(4) : Radius.circular(20),
      topRight: isMine
          ? isAboveMine ? Radius.circular(4) : Radius.circular(20)
          : Radius.circular(20),
      bottomLeft: isMine
          ? Radius.circular(20)
          : isBelowMine ? Radius.circular(4) : Radius.circular(20),
      bottomRight: isMine
          ? isBelowMine ? Radius.circular(4) : Radius.circular(20)
          : Radius.circular(20),
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: chatMessage.sender.isSameWithUser(hero)
            ? Colors.white
            : Theme.of(context).primaryColor,
        borderRadius: borderRadius,
      ),
      child: Text(
        chatMessage.body,
        style: TextStyle(
          color: chatMessage.sender.isSameWithUser(hero)
              ? Theme.of(context).textTheme.body1.color
              : Theme.of(context).primaryTextTheme.body1.color,
          height: 1.333,
        ),
      ),
    );
  }
}
