import 'package:caramel/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentReference;
import 'package:meta/meta.dart';

/// A reference to [User].
@immutable
abstract class UserReference {
  /// Creates a [UserReference] from Firebase [DocumentReference].
  factory UserReference.fromFirestoreDocumentReference(
    DocumentReference documentReference,
  ) =>
      _FirestoreUserReference.fromDocumentReference(documentReference);

  /// Obtains an [User].
  Future<User> resolve();

  /// 消すかも
  @deprecated
  bool isSameUser(User user);

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;
}

@immutable
class _FirestoreUserReference implements UserReference {
  const _FirestoreUserReference.fromDocumentReference(
    DocumentReference documentReference,
  )   : assert(documentReference != null),
        _documentReference = documentReference;

  final DocumentReference _documentReference;

  @override
  Future<User> resolve() async {
    final document = await _documentReference.get();

    return User.fromFirestoreDocument(document);
  }

  @override
  bool isSameUser(User user) => user.uid == _documentReference.documentID;

  @override
  bool operator ==(Object other) =>
      other is UserReference && other.hashCode == hashCode;

  @override
  int get hashCode => _documentReference.hashCode;
}
