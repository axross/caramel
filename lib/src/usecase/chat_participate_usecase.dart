import 'package:caramel/domains.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

/// A callable usecase to participate to a [Chat].
class ChatParticipateUsecase {
  /// Created a [ChatParticipateUsecase].
  ChatParticipateUsecase({@required chatRepository})
      : assert(chatRepository != null),
        _chatRepository = chatRepository;

  ChatRepository _chatRepository;

  /// Participate in the [Chat] by [chatId].
  ChatParticipationReference call({
    @required SignedInUser hero,
    @required String chatId,
  }) =>
      _ChatParticipationReference(
        hero: hero,
        chatId: chatId,
        chatRepository: _chatRepository,
      );
}

class _ChatParticipationReference implements ChatParticipationReference {
  _ChatParticipationReference({
    @required SignedInUser hero,
    @required String chatId,
    @required ChatRepository chatRepository,
  })  : assert(hero != null),
        assert(chatId != null),
        assert(chatRepository != null),
        _hero = hero,
        _chatId = chatId,
        _chatRepository = chatRepository;

  final SignedInUser _hero;

  final String _chatId;

  final ChatRepository _chatRepository;

  @override
  Future<ChatParticipation> get resolve => _chatRepository
      .getChatById(chatId: _chatId)
      .then((chat) => ChatParticipation(
            hero: _hero,
            chat: chat,
            chatRepository: _chatRepository,
          ));

  ChatParticipation _chatParticipation;

  @override
  ChatParticipation get value => _chatParticipation;
}
