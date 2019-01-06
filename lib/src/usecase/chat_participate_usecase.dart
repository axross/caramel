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
  ChatParticipation call({
    @required SignedInUser hero,
    @required String chatId,
  }) =>
      ChatParticipation(
        hero: hero,
        chat: _chatRepository.referChatById(id: chatId),
        chatRepository: _chatRepository,
      );
}
