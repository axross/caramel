import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;
import 'package:meta/meta.dart';

/// A special code to make a relationship with another user.
@immutable
abstract class FriendCode {
  /// Creates a [FriendCode] from Firebase [DocumentSnapshot].
  factory FriendCode.fromFirestoreDocument(DocumentSnapshot document) =>
      _FirestoreFriendCode.fromDocument(document);

  /// Creates a [FriendCode] from a [String].
  factory FriendCode.parse(String string) => _ParsedFriendCode.parse(string);

  /// String data.
  String get data;
}

@immutable
class _ParsedFriendCode implements FriendCode {
  factory _ParsedFriendCode.parse(String maybeCode) {
    if (!RegExp(r'^[0-9A-Za-z_\-]{20}$').hasMatch(maybeCode)) {
      throw FriendCodeParsingFailure(maybeCode);
    }

    return _ParsedFriendCode._(maybeCode);
  }

  const _ParsedFriendCode._(this.data);

  @override
  final String data;
}

@immutable
class _FirestoreFriendCode implements FriendCode {
  factory _FirestoreFriendCode.fromDocument(DocumentSnapshot documentSnapshot) {
    final id = documentSnapshot.documentID;

    return _FirestoreFriendCode._(id);
  }

  const _FirestoreFriendCode._(this.id) : assert(id != null);

  final String id;

  @override
  String get data => id;
}

///
@immutable
class FriendCodeParsingFailure implements Exception {
  /// Creates a [FriendCodeParsingFailure].
  const FriendCodeParsingFailure(this.data);

  /// A string.
  final String data;

  @override
  String toString() => 'FriendCodeParsingFailure: "$data" is not a valid code.';
}
