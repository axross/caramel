import 'package:flutter/material.dart';
import '../entity/chat_message.dart';
import './circle_avatar_by_user_reference.dart';

class ChatMessageItem extends StatelessWidget {
  final ChatMessage chatMessage;
  final bool isPreviousAnotherSender;
  final bool isNextAnotherSender;
  final bool isMine;

  ChatMessageItem({
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

  @override
  Widget build(BuildContext context) {
    if (chatMessage is TextChatMessage) {
      return Container(
        margin: isPreviousAnotherSender
            ? EdgeInsets.only(top: 16)
            : EdgeInsets.only(top: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: isMine
              ? [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.15 + 40,
                  ),
                  Expanded(
                    child: _Baloon(
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
                    child: _Baloon(
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

    return Container();
  }
}

class _Baloon extends StatelessWidget {
  final ChatMessage chatMessage;
  final bool isPreviousAnotherSender;
  final bool isNextAnotherSender;
  final bool isMine;

  _Baloon({
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

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: isPreviousAnotherSender
                ? Radius.circular(16)
                : Radius.circular(4),
            bottom:
                isNextAnotherSender ? Radius.circular(16) : Radius.circular(4),
          ),
        ),
        child: Text(
          (chatMessage as TextChatMessage).text,
          style: TextStyle(
            height: 1.333,
          ),
        ),
      );
}
