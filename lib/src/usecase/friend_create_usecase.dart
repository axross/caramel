import 'package:caramel/domains.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

/// A callable usecase to make [User]s to be friends.
class FriendCreateUsecase {
  /// Creates a [FriendCreateUsecase].
  FriendCreateUsecase({
    @required AtomicWriteCreator atomicWriteCreator,
    @required ChatRepository chatRepository,
    @required FriendCodeRepository friendCodeRepository,
    @required FriendCodeScanner friendCodeScanner,
    @required NotificationManager notificationManager,
    @required UserRepository userRepository,
  })  : assert(atomicWriteCreator != null),
        assert(chatRepository != null),
        assert(friendCodeRepository != null),
        assert(friendCodeScanner != null),
        assert(notificationManager != null),
        assert(userRepository != null),
        _atomicWriteCreator = atomicWriteCreator,
        _chatRepository = chatRepository,
        _friendCodeRepository = friendCodeRepository,
        _friendCodeScanner = friendCodeScanner,
        _notificationManager = notificationManager,
        _userRepository = userRepository;

  final NotificationManager _notificationManager;

  final ChatRepository _chatRepository;

  final UserRepository _userRepository;

  final FriendCodeRepository _friendCodeRepository;

  final FriendCodeScanner _friendCodeScanner;

  final AtomicWriteCreator _atomicWriteCreator;

  /// Read a [FriendCode] and make the user who issued it to be friends.
  void call({@required SignedInUser hero}) async {
    final friendCode = await _friendCodeScanner.scan();
    final chat = _chatRepository.referNewChat();
    final atomicWrite = _atomicWriteCreator.create();
    final opponent = await _userRepository.referUserByFriendCode(
      friendCode: friendCode,
    );

    await _userRepository.relateByFriendship(
      hero: hero,
      opponent: opponent,
      oneOnOneChat: chat,
      atomicWrite: atomicWrite,
    );

    await _chatRepository.createOneOnOneChat(
      hero: hero,
      opponent: opponent,
      chat: chat,
      atomicWrite: atomicWrite,
    );

    await _friendCodeRepository.delete(
      friendCode: friendCode,
      atomicWrite: atomicWrite,
    );

    await atomicWrite.commit();

    await _notificationManager.subscribeChat(
      chat: chat,
      hero: hero,
    );
  }
}
