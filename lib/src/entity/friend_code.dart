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

  /// 消すかも
  @deprecated
  String get code;
}

@immutable
class _ParsedFriendCode implements FriendCode {
  factory _ParsedFriendCode.parse(String maybeCode) {
    if (!RegExp(r'^[0-9A-Za-z_\-]{20}$').hasMatch(maybeCode)) {
      throw FriendCodeParsingFailure(maybeCode);
    }

    return _ParsedFriendCode._(maybeCode);
  }

  const _ParsedFriendCode._(this.code);

  @override
  final String code;
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
  String get code => id;
}

///
@immutable
class FriendCodeParsingFailure implements Exception {
  /// Creates a [FriendCodeParsingFailure].
  const FriendCodeParsingFailure(this.code);

  /// A string.
  final String code;

  @override
  String toString() => 'FriendCodeParsingFailure: "$code" is not a valid code.';
}
