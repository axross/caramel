import 'package:caramel/entities.dart';
import 'package:caramel/widgets.dart';
import 'package:flutter/material.dart';

class ChatMessageList extends StatelessWidget {
  ChatMessageList({
    Key key,
    @required this.user,
    @required this.chatMessages,
  })  : assert(user != null),
        assert(chatMessages != null),
        super(key: key);

  final User user;
  final List<ChatMessage> chatMessages;

  @override
  Widget build(BuildContext context) => ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        reverse: true,
        itemBuilder: (_, index) {
          final chatMessage = chatMessages[index];
          final previous =
              index == chatMessages.length - 1 ? null : chatMessages[index + 1];
          final next = index == 0 ? null : chatMessages[index - 1];

          return _ChatMessageListItem(
            chatMessage: chatMessage,
            isPreviousAnotherSender:
                previous == null || previous.from != chatMessage.from,
            isNextAnotherSender: next == null || next.from != chatMessage.from,
            isMine: chatMessage.from.isSameUser(user),
          );
        },
        itemCount: chatMessages.length,
      );
}

class _ChatMessageListItem extends StatelessWidget {
  _ChatMessageListItem({
    Key key,
    @required this.chatMessage,
    @required this.isPreviousAnotherSender,
    @required this.isNextAnotherSender,
    @required this.isMine,
  })  : assert(chatMessage != null),
        assert(isPreviousAnotherSender != null),
        assert(isNextAnotherSender != null),
        assert(isMine != null),
        super(key: key);

  final ChatMessage chatMessage;
  final bool isPreviousAnotherSender;
  final bool isNextAnotherSender;
  final bool isMine;

  @override
  Widget build(BuildContext context) => Container(
        margin: isPreviousAnotherSender
            ? EdgeInsets.only(top: 16)
            : EdgeInsets.only(top: 4),
        child: Row(
          children: isMine
              ? [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.15 + 40,
                  ),
                  Expanded(
                    child: _ChatMessageContent(
                      chatMessage: chatMessage,
                      isPreviousAnotherSender: isPreviousAnotherSender,
                      isNextAnotherSender: isNextAnotherSender,
                      isMine: isMine,
                    ),
                  ),
                ]
              : [
                  isPreviousAnotherSender
                      ? CircleAvatarByUserReference(
                          userReference: chatMessage.from)
                      : SizedBox(width: 40),
                  SizedBox(width: 8),
                  Expanded(
                    child: _ChatMessageContent(
                      chatMessage: chatMessage,
                      isPreviousAnotherSender: isPreviousAnotherSender,
                      isNextAnotherSender: isNextAnotherSender,
                      isMine: isMine,
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                ],
        ),
      );
}

class _ChatMessageContent extends StatelessWidget {
  _ChatMessageContent({
    Key key,
    @required this.chatMessage,
    @required this.isPreviousAnotherSender,
    @required this.isNextAnotherSender,
    @required this.isMine,
  })  : assert(chatMessage != null),
        assert(isPreviousAnotherSender != null),
        assert(isNextAnotherSender != null),
        assert(isMine != null),
        super(key: key);

  final ChatMessage chatMessage;
  final bool isPreviousAnotherSender;
  final bool isNextAnotherSender;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    if (chatMessage is TextChatMessage) {
      return _TextChatMessageContent(
        textChatMessage: chatMessage,
        isPreviousAnotherSender: isPreviousAnotherSender,
        isNextAnotherSender: isNextAnotherSender,
        isMine: isMine,
      );
    }

    return null;
  }
}

class _TextChatMessageContent extends StatelessWidget {
  _TextChatMessageContent({
    Key key,
    @required this.textChatMessage,
    @required this.isPreviousAnotherSender,
    @required this.isNextAnotherSender,
    @required this.isMine,
  })  : assert(textChatMessage != null),
        assert(isPreviousAnotherSender != null),
        assert(isNextAnotherSender != null),
        assert(isMine != null),
        super(key: key);

  final TextChatMessage textChatMessage;
  final bool isPreviousAnotherSender;
  final bool isNextAnotherSender;
  final bool isMine;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isMine ? Colors.white : Theme.of(context).accentColor,
          borderRadius: BorderRadius.vertical(
            top: isPreviousAnotherSender
                ? Radius.circular(16)
                : Radius.circular(4),
            bottom:
                isNextAnotherSender ? Radius.circular(16) : Radius.circular(4),
          ),
        ),
        child: Text(
          textChatMessage.text,
          style: TextStyle(
            color: isMine
                ? Theme.of(context).textTheme.body1.color
                : Theme.of(context).accentTextTheme.body1.color,
            height: 1.333,
          ),
        ),
      );
}
