import 'package:caramel/domains.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

/// A repository handling [User]s.
abstract class UserRepository {
  SignedInUserReference referByFirebaseAuthId({@required String id});

  Future<UserReference> referUserByFriendCode({
    @required FriendCode friendCode,
  });

  Future<void> registerUser({
    @required UserReference user,
    AtomicWrite atomicWrite,
  });

  Stream<Iterable<Friendship>> subscribeFriendships({
    @required SignedInUser hero,
  });

  Future<void> relateByFriendship({
    @required SignedInUser hero,
    @required UserReference opponent,
    @required ChatReference oneOnOneChat,
    AtomicWrite atomicWrite,
  });

  /// Deletes a friendship.
  Future<void> disrelateByFriendship({
    @required SignedInUser hero,
    @required Friendship friendship,
    AtomicWrite atomicWrite,
  });
}
