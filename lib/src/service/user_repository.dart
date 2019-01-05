import 'package:caramel/domains.dart';
import 'package:meta/meta.dart';

/// A repository handling [User]s.
abstract class UserRepository {
  /// Obtains an [User] from id.
  Future<SignedInUser> getUserById(String id);

  /// Register a new [User].
  Future<void> registerAsNewUser(String id);

  ///
  Stream<Iterable<Friendship>> subscribeFriendships({@required User hero});

  /// Adds a friend in [hero]'s friends by a [FriendCode].
  Future<void> addFriendByFriendCode({
    @required SignedInUser hero,
    @required FriendCode friendCode,
  });

  /// Deletes a friendship.
  Future<void> deleteFriendship({
    @required SignedInUser hero,
    @required Friendship friendship,
  });
}
