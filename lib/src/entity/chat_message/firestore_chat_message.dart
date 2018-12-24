import 'package:caramel/entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentReference, DocumentSnapshot;
import 'package:meta/meta.dart';

abstract class FirestoreChatMessage implements ChatMessage {
  FirestoreChatMessage factory FirestoreChatMessage.fromDocument(DocumentSnapshot document) {
    final maybeFrom = document.data['from'];
    final maybeSentAt = document.data['sentAt'];
    final maybeReadBy = document.data['readBy'];
    final maybeType = document.data['type'];

    assert(maybeFrom is DocumentReference);
    assert(maybeFrom != null);
    assert(maybeSentAt is DateTime);
    assert(maybeSentAt != null);
    assert(maybeReadBy is List);
    assert(maybeReadBy != null);
    assert(maybeType is String);
    assert(maybeType != null);

    final from = UserReference.fromFirestoreDocumentReference(maybeFrom);
    final readBy = (maybeReadBy as List).map((maybeUserDocumentReference) => UserReference.fromFirestoreDocumentReference(maybeUserDocumentReference)).toList();

    switch(maybeType) {
      case 'TEXT':
        return FirestoreTextChatMessage.fromDocument(document, from: from, sentAt: maybeSentAt, readBy: readBy,);
        break;
    }

    throw new Exception();
  }

  FirestoreChatMessage({
    @required this.from,
    @required this.sentAt,
    @required this.readBy,
  })  : assert(from != null),
        assert(sentAt != null),
        assert(readBy != null);
  
  final UserReference from;
  final DateTime sentAt;
  final List<UserReference> readBy;
}

class FirestoreTextChatMessage extends FirestoreChatMessage implements TextChatMessage  {
  FirestoreTextChatMessage factory FirestoreTextChatMessage.fromDocument(DocumentSnapshot document, { @required UserReference from, @required DateTime sentAt, @required List<UserReference> readBy, }) {
    final maybeText = document.data['text'];

    assert(maybeText is String);
    assert(maybeText != null);

    return FirestoreTextChatMessage._(
      from: from,
      sentAt: sentAt,
      readBy: readBy,
      text: maybeText,
    );
  }

  FirestoreTextChatMessage._({
    @required UserReference from,
    @required DateTime sentAt,
    @required List<UserReference> readBy,
    @required this.text,
  })  : assert(text != null),
        super(
    from: from,
    sentAt: sentAt,
    readBy: readBy,
  );

  final String text;
}
