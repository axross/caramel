import 'package:caramel/domains.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

/// A callable usecase to retrieve the [Chat]s.
class ChatListUsecase {
  /// Creates a [ChatListUsecase].
  ChatListUsecase({@required ChatRepository chatRepository})
      : assert(chatRepository != null),
        _chatRepository = chatRepository;

  ChatRepository _chatRepository;

  /// Retrieve the [Chat]s what the [hero] has participated in.
  ChatsObservable call({@required SignedInUser hero}) => _ChatsObservable(
        hero: hero,
        chatRepository: _chatRepository,
      );
}

class _ChatsObservable implements ChatsObservable {
  _ChatsObservable({
    @required SignedInUser hero,
    @required ChatRepository chatRepository,
  })  : assert(hero != null),
        assert(chatRepository != null),
        _hero = hero,
        _chatRepository = chatRepository;

  final SignedInUser _hero;

  final ChatRepository _chatRepository;

  @override
  Stream<Iterable<Chat>> get onChanged =>
      _chatRepository.subscribeChats(hero: _hero)
        ..listen((friendships) {
          _friendships = friendships;
        });

  Iterable<Chat> _friendships;

  @override
  Iterable<Chat> get latest => _friendships;
}
