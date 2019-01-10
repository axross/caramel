import 'package:caramel/domains.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

/// An usecase callable class to delete a [Friendship].
class FriendshipDeleteUsecase {
  /// Creates a [FriendshipDeleteUsecase].
  FriendshipDeleteUsecase({
    @required UserRepository userRepository,
  })  : assert(userRepository != null),
        _userRepository = userRepository;

  final UserRepository _userRepository;

  /// Deletes the [friendship].
  void call({
    @required SignedInUser hero,
    @required Friendship friendship,
  }) async {
    await _userRepository.deleteFriendship(
      hero: hero,
      friendship: friendship,
    );
  }
}
