import 'package:caramel/domains.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

/// An usecase callable class to delete a [Friendship].
class FriendshipDeleteUsecase {
  /// Creates a [FriendshipDeleteUsecase].
  FriendshipDeleteUsecase({
    @required AtomicWriteCreator atomicWriteCreator,
    @required ChatRepository chatRepository,
    @required NotificationManager notificationManager,
    @required UserRepository userRepository,
  })  : assert(atomicWriteCreator != null),
        assert(chatRepository != null),
        assert(notificationManager != null),
        assert(userRepository != null),
        _atomicWriteCreator = atomicWriteCreator,
        _chatRepository = chatRepository,
        _notificationManager = notificationManager,
        _userRepository = userRepository;

  final AtomicWriteCreator _atomicWriteCreator;

  final ChatRepository _chatRepository;

  final NotificationManager _notificationManager;

  final UserRepository _userRepository;

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

    await _notificationManager.subscribeChat(
      chat: friendship.oneOnOneChat,
      hero: hero,
    );
  }
}
