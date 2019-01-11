import 'package:caramel/domains.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

/// A value object expressing a participation in a [Chat].
abstract class ChatParticipation {
  /// Creates [ChatParticipation].
  factory ChatParticipation({
    @required SignedInUser hero,
    @required ChatReference chat,
    @required ChatRepository chatRepository,
  }) =>
      _ChatParticipation(
        hero: hero,
        chat: chat,
        chatRepository: chatRepository,
      );

  SignedInUser get hero;

  /// The chat.
  ChatReference get chat;

  /// Posts a [TextChatMessage] in the chat.
  void postText(String text);
}

class _ChatParticipation implements ChatParticipation {
  _ChatParticipation({
    @required this.hero,
    @required this.chat,
    @required ChatRepository chatRepository,
  })  : assert(hero != null),
        assert(chat != null),
        assert(chatRepository != null),
        _chatRepository = chatRepository;

  final ChatRepository _chatRepository;

  @override
  final SignedInUser hero;

  @override
  final ChatReference chat;

  @override
  void postText(String text) => _chatRepository.postTextToChat(
        hero: hero,
        chat: chat,
        text: text,
      );
}
