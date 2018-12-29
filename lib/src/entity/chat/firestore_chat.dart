import 'package:caramel/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart'
    show DocumentReference, DocumentSnapshot;
import 'package:meta/meta.dart';

class FirestoreChat with ChatStruct, ToReferenceMixin implements Chat {
  factory FirestoreChat.fromDocument(DocumentSnapshot document) {
    final id = document.documentID;
    final maybeMembers = document.data['members'];
    final maybeLastChatMessage = document.data['lastChatMessage'];

    assert(maybeMembers is Iterable);
    assert(maybeLastChatMessage == null ||
        maybeLastChatMessage is DocumentReference);

    final members = (maybeMembers as Iterable).map(
      (maybeMember) =>
          UserReference.fromFirestoreDocumentReference(maybeMember),
    );
    final lastChatMessage = maybeLastChatMessage == null
        ? null
        : ChatMessageReference.fromFirestoreDocumentReference(
            maybeLastChatMessage);

    return FirestoreChat._(
      id: id,
      members: members,
      lastChatMessage: lastChatMessage,
    );
  }

  FirestoreChat._({
    @required this.id,
    @required this.members,
    this.lastChatMessage,
  })  : assert(id != null),
        assert(members != null);

  final String id;
  final Iterable<UserReference> members;
  final ChatMessageReference lastChatMessage;
}
