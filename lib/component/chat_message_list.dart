import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../entity/chat_message.dart';
import '../model/chat_model.dart';
import './chat_message_item.dart';
import './unsafe_authenticated.dart';

class ChatMessageList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final chatModel = Provider.of<ChatModel>(context);

    return UnsafeAuthenticated(
      builder: (_, user) => StreamBuilder<List<ChatMessage>>(
            stream: chatModel.onChange,
            builder: (_, snapshot) => snapshot.hasData
                ? ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    reverse: true,
                    itemBuilder: (_, index) {
                      final chatMessage = snapshot.requireData[index];
                      final previous = index == snapshot.requireData.length - 1
                          ? null
                          : snapshot.requireData[index + 1];
                      final next =
                          index == 0 ? null : snapshot.requireData[index - 1];

                      return ChatMessageItem(
                        chatMessage: snapshot.requireData[index],
                        isPreviousAnotherSender: previous == null ||
                            previous.from != chatMessage.from,
                        isNextAnotherSender:
                            next == null || next.from != chatMessage.from,
                        isMine: chatMessage.from.isSameUser(user),
                      );
                    },
                    itemCount: snapshot.requireData.length,
                  )
                : Container(),
          ),
    );
  }
}
