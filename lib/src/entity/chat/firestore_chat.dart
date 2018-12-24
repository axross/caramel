import 'package:caramel/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;
import 'package:meta/meta.dart';

class FirestoreChat implements Chat {
  final String id;
  final Iterable<UserReference> members;

  FirestoreChat factory FirestoreChat.fromDocument(DocumentSnapshot document) {
    final id = document.documentID;
    final maybeMembers = document.data['members'];

    assert(maybeMembers is Iterable);

    final members = (maybeMembers as Iterable)
      .map((maybeMember) =>
        UserReference.fromFirestoreDocumentReference(maybeMember),
      );

    return FirestoreChat._(id: id, members: members);
  }

  FirestoreChat._({@required this.id, @required this.members})
      : assert(id != null),
        assert(members != null);
}
