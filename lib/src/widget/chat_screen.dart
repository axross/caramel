import 'package:caramel/domains.dart';
import 'package:caramel/widgets.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({
    @required ChatParticipation chatParticipation,
    Key key,
  })  : assert(chatParticipation != null),
        _chatParticipation = chatParticipation,
        super(key: key);

  final ChatParticipation _chatParticipation;

  @override
  Widget build(BuildContext context) => FutureBuilder<Chat>(
        future: _chatParticipation.chat,
        initialData: _chatParticipation.chat.value,
        builder: (context, chatSnapshot) => Scaffold(
              appBar: AppBar(
                title: chatSnapshot.hasData
                    ? FutureBuilder<List<User>>(
                        future: chatSnapshot.requireData.participants,
                        initialData:
                            chatSnapshot.requireData.participants.value,
                        builder: (_, participantsSnapshot) =>
                            participantsSnapshot.hasData
                                ? Text(
                                    participantsSnapshot.requireData
                                        .firstWhere((participant) =>
                                            participant !=
                                            _chatParticipation.hero)
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
                                hero: _chatParticipation.hero,
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
                              chatParticipation: _chatParticipation,
                            )
                          : Container(),
                    ),
                  ],
                ),
              ),
            ),
      );
}
