import 'package:caramel/domains.dart';

/// An entity expressing a relationship of a [SignedInUser] and another
/// (friend) [User].
abstract class Friendship with Entity {
  /// The friend.
  OtherUserReference get user;

  /// The chat which is one-on-one with the friend user.
  ChatReference get oneOnOneChat;
}
