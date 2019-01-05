import 'package:caramel/domains.dart';

/// An value expressing a code to add an [User] to the user's friends.
/// [FriendCode]s are available to use only once. After it's used, the new one
/// should be issued.
abstract class FriendCode {
  /// The data.
  String get data;
}
