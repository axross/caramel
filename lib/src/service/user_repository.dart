import 'package:caramel/domains.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

/// A repository handling [User]s.
abstract class UserRepository {
  SignedInUserReference referByFirebaseAuthId({@required String id});

  Future<UserReference> referUserByFriendCode({
    @required FriendCode friendCode,
  });

  Stream<Iterable<Friendship>> subscribeFriendships({
    @required SignedInUser hero,
  });

  Future<void> createFriendshipByFriendCode({
    @required FriendCode friendCode,
  });

  /// Deletes a friendship.
  Future<void> deleteFriendship({
    @required SignedInUser hero,
    @required Friendship friendship,
  });

  Future<void> createUser({@required String id});

  Future<void> setDevice({
    @required SignedInUser hero,
    @required DeviceInformation deviceInformation,
    @required String pushNotificationDestinationId,
  });
}
