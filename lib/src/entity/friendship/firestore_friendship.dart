import 'package:caramel/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart'
    show DocumentReference, DocumentSnapshot;
import 'package:meta/meta.dart';

class FirestoreFriendship implements Friendship {
  factory FirestoreFriendship.fromDocument(DocumentSnapshot document) {
    final maybeUser = document.data['user'];

    assert(maybeUser is DocumentReference);

    return FirestoreFriendship._(
      user: UserReference.fromFirestoreDocumentReference(maybeUser),
    );
  }

  FirestoreFriendship._({
    @required this.user,
  }) : assert(user != null);

  @override
  final UserReference user;
}
