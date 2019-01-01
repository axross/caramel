import 'dart:async';
import 'package:caramel/entities.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

class ChatModel {
  ChatModel({
    @required Chat chat,
    @required User user,
    @required ChatMessageRepositoryService chatMessageRepositoryService,
  })  : assert(chat != null),
        assert(user != null),
        assert(chatMessageRepositoryService != null),
        _chat = chat,
        _user = user,
        _chatMessageRepositoryService = chatMessageRepositoryService {
    _postingText.stream.listen((text) async {
      await _chatMessageRepositoryService.postText(
        text: text,
        chat: _chat,
        user: _user,
      );
    });
  }

  final ChatMessageRepositoryService _chatMessageRepositoryService;
  final Chat _chat;
  final User _user;
  Iterable<ChatMessage> _chatMessages = [];

  final StreamController<String> _postingText = StreamController();

  Stream<Iterable<ChatMessage>> get onChanged =>
      _chatMessageRepositoryService.subscribeChatMessages(_chat)
        ..listen((chatMessages) {
          _chatMessages = chatMessages;
        });

  Sink<String> get postingText => _postingText.sink;

  Iterable<ChatMessage> get chatMessages => _chatMessages;

  void dispose() {
    _postingText.close();
  }
}
