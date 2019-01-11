import 'package:caramel/domains.dart';
import 'package:caramel/usecases.dart';
import 'package:caramel/widgets.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({
    @required SignedInUser hero,
    @required String chatId,
    Key key,
  })  : assert(hero != null),
        assert(chatId != null),
        _hero = hero,
        _chatId = chatId,
        super(key: key);

  final SignedInUser _hero;

  final String _chatId;

  @override
  Widget build(BuildContext context) {
    final participateChat = Provider.of<ChatParticipateUsecase>(context);

    final chatParticipation = participateChat(
      hero: _hero,
      chatId: _chatId,
    );

    return FutureBuilder<Chat>(
      future: chatParticipation.chat,
      initialData: chatParticipation.chat.value,
      builder: (context, chatSnapshot) => Scaffold(
            appBar: AppBar(
              title: chatSnapshot.hasData
                  ? FutureBuilder<List<User>>(
                      future: chatSnapshot.requireData.participants,
                      initialData: chatSnapshot.requireData.participants.value,
                      builder: (_, participantsSnapshot) =>
                          participantsSnapshot.hasData
                              ? Text(
                                  participantsSnapshot.requireData
                                      .firstWhere(
                                          (participant) => participant != _hero)
                                      .name,
                                )
                              : const Text('Loading...'),
                    )
                  : const Text('Loading...'),
              elevation: 2,
            ),
            body: Container(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[50],
                      ),
                      child: chatSnapshot.hasData
                          ? ChatMessageList(
                              hero: _hero,
                              chatMessages:
                                  chatSnapshot.requireData.chatMessages,
                            )
                          : Container(),
                    ),
                  ),
                  Material(
                    elevation: 4,
                    child: chatSnapshot.hasData
                        ? ChatMessageInput(
                            chatParticipation: chatParticipation,
                          )
                        : Container(),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
