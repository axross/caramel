import 'package:caramel/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentReference, DocumentSnapshot;
import 'package:meta/meta.dart';

class FirestoreFriendship implements Friendship {
  FirestoreFriendship factory FirestoreFriendship.fromDocument( DocumentSnapshot document) {
    final maybeUser = document.data['user'];
    final maybeChat = document.data['chat'];

    assert(maybeUser is DocumentReference);
    assert(maybeChat is DocumentReference);

    return FirestoreFriendship._(
      user: UserReference.fromFirestoreDocumentReference(maybeUser),
      chat: ChatReference.fromFirestoreDocumentReference(maybeChat),
    );
  }

  FirestoreFriendship._({
    @required this.user,
    @required this.chat,
  })  : assert(user != null),
        assert(chat != null);

  final UserReference user;
  final ChatReference chat;
}
