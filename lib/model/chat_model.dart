import 'dart:async';
import 'package:meta/meta.dart';
import '../entity/chat.dart';
import '../entity/chat_message.dart';
import '../entity/user.dart';
import '../service/chat_message_repository_service.dart';

class ChatModel {
  final ChatMessageRepositoryService _chatMessageRepositoryService;
  final Chat _chat;
  final User _user;
  List<ChatMessage> _chatMessages;

  // input
  StreamController<String> _postingText = StreamController();

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
      print(text);

      await _chatMessageRepositoryService.postText(
        text: text,
        chat: _chat,
        me: _user,
      );
    });
  }

  Stream<List<ChatMessage>> get onChange =>
      _chatMessageRepositoryService.subscribeChatMessages(_chat)
        ..listen((chatMessages) {
          _chatMessages = chatMessages;
        });

  Sink<String> get postingText => _postingText.sink;

  List<ChatMessage> get chatMessages => _chatMessages;

  void dispose() {
    _postingText.close();
  }
}
