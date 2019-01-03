import 'dart:async';
import 'package:caramel/entities.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

/// A model managing the list of [ChatMessage]s in the [Chat].
///
/// When the instance doesn't need anymore, [dispose()] should be called.
abstract class ChatModel {
  /// Creates a [ChatModel].
  factory ChatModel({
    @required Chat chat,
    @required User user,
    @required ChatMessageRepositoryService chatMessageRepositoryService,
  }) =>
      _ChatModel(
        chat: chat,
        user: user,
        chatMessageRepositoryService: chatMessageRepositoryService,
      );

  /// Fires whenever the list of [ChatMessage]s changes.
  Stream<Iterable<ChatMessage>> get onChanged;

  /// The [Sink] to request posting a new [TextChatMessage].
  Sink<String> get postingText;

  /// The current list of [ChatMessage]s.
  Iterable<ChatMessage> get chatMessages;

  /// Closes all [Sink]s used in the instance. This method should be called
  /// when the instance doesn't need anymore.
  void dispose();
}

class _ChatModel implements ChatModel {
  _ChatModel({
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
