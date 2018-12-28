import 'package:caramel/entities.dart';
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
    assert(maybeSentAt == null || maybeSentAt is DateTime);
    assert(maybeReadBy is List);
    assert(maybeReadBy != null);
    assert(maybeType is String);
    assert(maybeType != null);

    final from = UserReference.fromFirestoreDocumentReference(maybeFrom);
    final readBy = (maybeReadBy as List).map((maybeUserDocumentReference) => UserReference.fromFirestoreDocumentReference(maybeUserDocumentReference)).toList();
    final sentAt = maybeSentAt == null ? DateTime.now() : maybeSentAt;

    switch(maybeType) {
      case 'TEXT':
        return FirestoreTextChatMessage._fromDocument(document, from: from, sentAt: sentAt, readBy: readBy,);
        break;
    }

    throw new Exception();
  }
  
  final UserReference from;
  final DateTime sentAt;
  final Iterable<UserReference> readBy;
}

class FirestoreTextChatMessage implements FirestoreChatMessage, TextChatMessage {
  FirestoreTextChatMessage factory FirestoreTextChatMessage._fromDocument(
    DocumentSnapshot document, {
      @required UserReference from,
      @required DateTime sentAt,
      @required Iterable<UserReference> readBy,
  }) {
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
    @required this.from,
    @required this.sentAt,
    @required this.readBy,
    @required this.text,
  })  : assert(from != null),assert(sentAt != null),assert(readBy != null),assert(text != null);

  final UserReference from;
  final DateTime sentAt;
  final Iterable<UserReference> readBy;
  final String text;
}
