import 'package:caramel/entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;
import 'package:meta/meta.dart';

class FirestoreChat implements Chat {
  final String id;
  final List<UserReference> members;

  FirestoreChat factory FirestoreChat.fromDocument(DocumentSnapshot document) {
    final id = document.documentID;
    final maybeMembers = document.data['members'];

    assert(maybeMembers is List);

    final members = (maybeMembers as List).map((maybeMember) => UserReference.fromFirestoreDocumentReference(maybeMember)).toList();

    return FirestoreChat._(id: id, members: members);
  }

  FirestoreChat._({@required this.id, @required this.members})
      : assert(id != null),
        assert(members != null);
}
