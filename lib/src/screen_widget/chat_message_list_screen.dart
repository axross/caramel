import 'package:caramel/entities.dart';
import 'package:caramel/models.dart';
import 'package:caramel/model_creators.dart';
import 'package:caramel/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatMessageListScreen extends StatelessWidget {
  const ChatMessageListScreen({
    @required this.chatReference,
    Key key,
  })  : assert(chatReference != null),
        super(key: key);

  final ChatReference chatReference;

  @override
  Widget build(BuildContext context) {
    final chatModelCreator = Provider.of<ChatModelCreator>(context);

    return Authenticated(
      authenticatedBuilder: (_, user) => FutureBuilder<Chat>(
            future: chatReference.resolve(),
            builder: (_, snapshot) => snapshot.hasData
                ? _ChatMessageListScreenInner(
                    chat: snapshot.requireData,
                    user: user,
                    chatModelCreator: chatModelCreator,
                  )
                : Container(),
          ),
      unauthenticatedBuilder: (_) => Container(),
    );
  }
}

class _ChatMessageListScreenInner extends StatefulWidget {
  const _ChatMessageListScreenInner({
    @required this.chat,
    @required this.user,
    @required this.chatModelCreator,
    Key key,
  })  : assert(chat != null),
        assert(user != null),
        assert(chatModelCreator != null),
        super(key: key);

  final Chat chat;
  final User user;
  final ChatModelCreator chatModelCreator;

  @override
  State<StatefulWidget> createState() => _ChatMessageListScreenInnerState();
}

class _ChatMessageListScreenInnerState
    extends State<_ChatMessageListScreenInner> {
  ChatModel _chatModel;

  @override
  void initState() {
    super.initState();

    _chatModel = widget.chatModelCreator.createModel(
      chat: widget.chat,
      user: widget.user,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: FutureBuilder<User>(
            future: widget.chat.members
                .firstWhere((member) => !member.isSameUser(widget.user))
                .resolve(),
            builder: (_, ss) => ss.hasData
                ? Text(ss.requireData.name)
                : const Text('Loading...'),
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
                  child: StreamBuilder<Iterable<ChatMessage>>(
                    stream: _chatModel.onChanged,
                    initialData: _chatModel.chatMessages,
                    builder: (_, snapshot) => snapshot.hasData
                        ? ChatMessageList(
                            user: widget.user,
                            chatMessages: snapshot.requireData.toList(),
                          )
                        : Container(),
                  ),
                ),
              ),
              Material(
                elevation: 4,
                child: ChatMessageInput(
                  onSubmitted: (text) => _chatModel.postingText.add(text),
                ),
              ),
            ],
          ),
        ),
      );
}
