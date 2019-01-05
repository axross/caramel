import 'package:caramel/domains.dart';

/// An entity expressing a relationship of a [SignedInUser] and another
/// (friend) [User].
abstract class Friendship with IdentifiableById<Friendship> {
  /// The friend.
  UserReference get user;

  /// The chat which is one-on-one with the friend user.
  ChatReference get oneOnOneChat;
}
