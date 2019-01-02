import 'dart:async';
import 'package:caramel/entities.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

abstract class ChatModel {
  factory ChatModel({
    @required Chat chat,
    @required User user,
    @required ChatMessageRepositoryService chatMessageRepositoryService,
  }) =>
      _ChatModelImpl(
        chat: chat,
        user: user,
        chatMessageRepositoryService: chatMessageRepositoryService,
      );

  Stream<Iterable<ChatMessage>> get onChanged;

  Sink<String> get postingText;

  Iterable<ChatMessage> get chatMessages;

  void dispose();
}

class _ChatModelImpl implements ChatModel {
  _ChatModelImpl({
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

  @override
  Stream<Iterable<ChatMessage>> get onChanged =>
      _chatMessageRepositoryService.subscribeChatMessages(_chat)
        ..listen((chatMessages) {
          _chatMessages = chatMessages;
        });

  @override
  Sink<String> get postingText => _postingText.sink;

  @override
  Iterable<ChatMessage> get chatMessages => _chatMessages;

  @override
  void dispose() {
    _postingText.close();
  }
}
