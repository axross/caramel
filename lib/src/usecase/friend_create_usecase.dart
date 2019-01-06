import 'package:caramel/domains.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

/// A callable usecase to make [User]s to be friends.
class FriendCreateUsecase {
  /// Creates a [FriendCreateUsecase].
  FriendCreateUsecase({
    @required FriendCodeScanner friendCodeScanner,
    @required UserRepository userRepository,
  })  : assert(friendCodeScanner != null),
        assert(userRepository != null),
        _friendCodeScanner = friendCodeScanner,
        _userRepository = userRepository;

  ChatRepository _chatRepository;

  UserRepository _userRepository;

  FriendCodeRepository _friendCodeRepository;

  FriendCodeScanner _friendCodeScanner;

  AtomicWriteCreator _atomicWriteCreator;

  /// Read a [FriendCode] and make the user who issued it to be friends.
  void call({@required SignedInUser hero}) async {
    final friendCode = await _friendCodeScanner.scan();
    final chatReference = _chatRepository.referNewChat();
    final atomicWrite = _atomicWriteCreator.create();
    final opponent = await _userRepository.referUserByFriendCode(
      friendCode: friendCode,
    );

    await _userRepository.relateByFriendship(
      hero: hero,
      opponent: opponent,
      oneOnOneChat: chatReference,
      atomicWrite: atomicWrite,
    );

    await _chatRepository.createOneOnOneChat(
      hero: hero,
      opponent: opponent,
      chatReference: chatReference,
      atomicWrite: atomicWrite,
    );

    await _friendCodeRepository.delete(
      friendCode: friendCode,
      atomicWrite: atomicWrite,
    );

    await atomicWrite.commit();
  }
}
