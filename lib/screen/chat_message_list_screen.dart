// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../component/authenticated_screen.dart';
import '../component/chat_message_adder.dart';
import '../component/chat_message_list.dart';
import '../entity/chat.dart';
import '../entity/chat_reference.dart';
import '../entity/user.dart';
import '../model_creator/chat_model_creator.dart';

class ChatMessageListScreen extends StatelessWidget {
  final ChatReference chatReference;

  ChatMessageListScreen({Key key, @required this.chatReference})
      : assert(chatReference != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatModelCreator = Provider.of<ChatModelCreator>(context);

    return AuthenticatedScreen(
      builder: (_, user) => FutureBuilder<Chat>(
            future: chatReference.resolve(),
            builder: (_, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }

              final chatModel = chatModelCreator.createModel(
                chat: snapshot.requireData,
                user: user,
              );

              return Provider(
                value: chatModel,
                child: Scaffold(
                  appBar: AppBar(
                    title: FutureBuilder<User>(
                      future: snapshot.requireData.members
                          .firstWhere((member) => member.isSameUser(user))
                          .resolve(),
                      builder: (_, ss) => ss.hasData
                          ? Text(ss.requireData.name)
                          : Text('Loading...'),
                    ),
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
                            child: ChatMessageList(),
                          ),
                        ),
                        ChatMessageAdder(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
    );
  }
}
