import 'package:caramel/domains.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

/// A repository handling [FriendCode]s.
abstract class FriendCodeRepository {
  /// Subscribes the newest [FriendCode].
  Stream<FriendCode> subscribeNewestFriendCode({@required SignedInUser hero});

  /// Issues a new [FriendCode].
  Future<void> create({
    @required SignedInUser hero,
    AtomicWrite atomicWrite,
  });
}
