import 'package:caramel/domains.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

/// A callable usecase to retrieve the [Chat]s.
class ChatListUsecase {
  /// Creates a [ChatListUsecase].
  ChatListUsecase({@required ChatRepository chatRepository})
      : assert(chatRepository != null),
        _chatRepository = chatRepository;

  final ChatRepository _chatRepository;

  /// Retrieve the [Chat]s what the [hero] has participated in.
  StatefulStream<List<Chat>> call({@required SignedInUser hero}) =>
      StatefulStream(
        _chatRepository.subscribeChats(hero: hero),
      );
}
