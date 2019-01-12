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
        builder: (context, chatSnapshot) => chatSnapshot.hasData
            ? FutureBuilder<List<User>>(
                future: chatSnapshot.requireData.participants,
                initialData: chatSnapshot.requireData.participants.value,
                builder: (_, participantsSnapshot) => Scaffold(
                      appBar: AppBar(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        textTheme: Theme.of(context).textTheme.apply(
                              bodyColor: Colors.black,
                            ),
                        centerTitle: true,
                        elevation: 2,
                        title:
                            chatSnapshot.hasData && participantsSnapshot.hasData
                                ? Text(participantsSnapshot.requireData
                                    .firstWhere((participant) =>
                                        participant != _chatParticipation.hero)
                                    .name)
                                : Text('Loading...'),
                      ),
                      body: Column(
                        children: [
                          Expanded(
                            child: StreamBuilder<List<ChatMessage>>(
                              stream: chatSnapshot.requireData.chatMessages,
                              initialData:
                                  chatSnapshot.requireData.chatMessages.latest,
                              builder: (context, chatMessagesSnapshot) {
                                if (!chatMessagesSnapshot.hasData) {
                                  return Container();
                                }

                                final reversedChatMessages =
                                    chatMessagesSnapshot.requireData
                                      ..sort((a, b) =>
                                          b.sentAt.compareTo(a.sentAt));

                                return ListView.builder(
                                  padding: EdgeInsets.all(12),
                                  reverse: true,
                                  itemBuilder: (context, i) =>
                                      ChatMessageListTile(
                                        hero: _chatParticipation.hero,
                                        chatMessage: reversedChatMessages[i],
                                        aboveChatMessage:
                                            i >= reversedChatMessages.length - 1
                                                ? null
                                                : reversedChatMessages[i + 1],
                                        belowChatMessage: i == 0
                                            ? null
                                            : reversedChatMessages[i - 1],
                                      ),
                                  itemCount: reversedChatMessages.length,
                                );
                              },
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
              )
            : Container(),
      );
}
