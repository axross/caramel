import 'package:caramel/domains.dart';
import 'package:meta/meta.dart';

abstract class ResourceNotExisting implements Exception {}

/// An exception that the [User] doesn't exist  in the database.
class UserNotExisting implements Exception, ResourceNotExisting {
  /// Creates an [UserNotExisting].
  UserNotExisting({@required String id}) : _id = id;

  final String _id;

  @override
  String toString() => 'UserNotExisting: An user (id = $_id) doesn\'t exist.';
}

class InvalidFriendCodeScanned implements Exception, ResourceNotExisting {
  /// Creates an [InvalidFriendCodeScanned].
  InvalidFriendCodeScanned({@required this.data}) : assert(data != null);

  /// The scanned data.
  final String data;

  @override
  String toString() =>
      'InvalidFriendCodeScanned: An invalid friend code is scanned. '
      '(data = $data)';
}

/// An exception that the [FriendCode] doesn't exist in the database.
class FriendCodeNotExisting
    implements Exception, ResourceNotExisting, InvalidFriendCodeScanned {
  /// Creates an [FriendCodeNotExisting].
  FriendCodeNotExisting({@required this.friendCode})
      : assert(friendCode != null);

  /// The friend code tried to retrieve.
  final FriendCode friendCode;

  @override
  String get data => friendCode.data;

  @override
  String toString() =>
      'FriendCodeNotExisting: A friend code (data = $data) doesn\'t exist.';
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

class ServerInternalException implements Exception {
  ServerInternalException({@required String message}) : _message = message;

  final String _message;

  @override
  String toString() => 'ServerInternalException: $_message';
}

class FriendCodeParsingFailure implements Exception, InvalidFriendCodeScanned {
  /// Creates a [FriendCodeParsingFailure].
  const FriendCodeParsingFailure(this.data);

  @override
  final String data;

  @override
  String toString() => 'FriendCodeParsingFailure: "$data" is not a valid code.';
}

///
class ScanCancelled implements Exception {
  ///
  ScanCancelled();

  @override
  String toString() => 'ScanCancelled: scaning barcode has been cancelled.';
}

class AlreadyFriend implements Exception {
  AlreadyFriend();

  @override
  String toString() =>
      'AlreadyFriend: the hero and the user are already friends.';
}
