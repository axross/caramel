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

  final UserRepository _userRepository;

  final FriendCodeScanner _friendCodeScanner;

  /// Read a [FriendCode] and make the user who issued it to be friends.
  Future<void> call() async {
    FriendCode friendCode;

    try {
      friendCode = await _friendCodeScanner.scan();
    } on ScanCancelled {
      return;
    }

    await _userRepository.createFriendshipByFriendCode(
      friendCode: friendCode,
    );
  }
}
