import 'package:caramel/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart'
    show DocumentReference, DocumentSnapshot;
import 'package:meta/meta.dart';

/// A relationship from an [User] to another [User].
@immutable
abstract class Friendship {
  /// Creates [Friendship] from a Firebase [DocumentSnapshot].
  factory Friendship.fromFirestoreDocument(DocumentSnapshot document) =>
      _FirestoreFriendship.fromDocument(document);

  /// The friend user.
  UserReference get user;
}

@immutable
class _FirestoreFriendship implements Friendship {
  factory _FirestoreFriendship.fromDocument(DocumentSnapshot document) {
    final maybeUser = document.data['user'];

    assert(maybeUser is DocumentReference);

    return _FirestoreFriendship._(
      user: UserReference.fromFirestoreDocumentReference(maybeUser),
    );
  }

  const _FirestoreFriendship._({
    @required this.user,
  }) : assert(user != null);

  @override
  final UserReference user;
}
