import 'package:caramel/domains.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

/// An usecase callable class to delete a [Friendship].
class FriendshipDeleteUsecase {
  /// Creates a [FriendshipDeleteUsecase].
  FriendshipDeleteUsecase({
    @required ChatRepository chatRepository,
    @required UserRepository userRepository,
    @required AtomicWriteCreator atomicWriteCreator,
  })  : assert(chatRepository != null),
        assert(userRepository != null),
        assert(atomicWriteCreator != null),
        _chatRepository = chatRepository,
        _userRepository = userRepository,
        _atomicWriteCreator = atomicWriteCreator;

  final ChatRepository _chatRepository;

  final UserRepository _userRepository;

  final AtomicWriteCreator _atomicWriteCreator;

  /// Deletes the [friendship].
  void call({
    @required SignedInUser hero,
    @required Friendship friendship,
  }) async {
    final atomicWrite = _atomicWriteCreator.create();

    await _userRepository.disrelateByFriendship(
      hero: hero,
      friendship: friendship,
    );

    await _chatRepository.deleteChat(chat: friendship.oneOnOneChat);

    await atomicWrite.commit();
  }
}
