import 'package:caramel/domains.dart';
import 'package:meta/meta.dart';

/// An exception that the [User] doesn't exist  in the database.
class UserNotExisting implements Exception {
  /// Creates an [UserNotExisting].
  UserNotExisting({@required String id}) : _id = id;

  final String _id;

  @override
  String toString() => 'UserNotExisting: An user (id = $_id) doesn\'t exist.';
}

/// An exception that the [FriendCode] doesn't exist in the database.
class FriendCodeNotExisting implements Exception {
  /// Creates an [FriendCodeNotExisting].
  FriendCodeNotExisting({@required this.friendCode})
      : assert(friendCode != null);

  /// The friend code tried to retrieve.
  final FriendCode friendCode;

  @override
  String toString() =>
      'FriendCodeNotExisting: A friend code (data = ${friendCode.data}) '
      'doesn\'t exist.';
}

/// An exception that the [Chat] doesn't exist  in the database.
class ChatNotExisting implements Exception {
  /// Creates an [ChatNotExisting].
  ChatNotExisting({@required String id}) : _id = id;

  final String _id;

  @override
  String toString() => 'ChatNotExisting: A chat (id = $_id) doesn\'t exist.';
}

/// An error that something in the database is unexpected state.
class DatabaseBadState extends Error {
  /// Creates a [DatabaseBadState].
  DatabaseBadState({String detail}) : _detail = detail;

  final String _detail;

  @override
  String toString() =>
      'DatabaseBadState: something in the database is unexpected state.' +
                  _detail ==
              null
          ? ''
          : '\nDetail: $_detail';
}
