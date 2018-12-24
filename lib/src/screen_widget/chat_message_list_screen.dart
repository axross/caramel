import 'package:caramel/entity.dart';
import 'package:caramel/model_creator.dart';
import 'package:caramel/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatMessageListScreen extends StatelessWidget {
  ChatMessageListScreen({Key key, @required this.chatReference})
      : assert(chatReference != null),
        super(key: key);

  final ChatReference chatReference;

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
                            child: ChatMessageList(user: user),
                          ),
                        ),
                        Material(
                          elevation: 4.0,
                          child: ChatMessageInput(),
                        ),
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
