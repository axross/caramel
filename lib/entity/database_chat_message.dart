import 'package:cloud_firestore/cloud_firestore.dart' show DocumentReference, DocumentSnapshot;
import 'package:meta/meta.dart';
import './chat_message.dart';
import './database_user_reference.dart';
import './user_reference.dart';

abstract class DatabaseChatMessage implements ChatMessage {
  final UserReference from;
  final DateTime sentAt;
  final List<UserReference> readBy;

  DatabaseChatMessage factory DatabaseChatMessage.fromDocument(DocumentSnapshot document) {
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

    final from = DatabaseUserReference.fromDocumentReference(maybeFrom);
    final readBy = (maybeReadBy as List).map((maybeUserDocumentReference) => DatabaseUserReference.fromDocumentReference(maybeUserDocumentReference)).toList();

    switch(stringToChatMessageType(maybeType)) {
      case ChatMessageType.Text:
        return DatabaseTextChatMessage.fromDocument(document, from: from, sentAt: maybeSentAt, readBy: readBy,);
        break;
    }

    throw new Exception();
  }

  DatabaseChatMessage({
    @required this.from,
    @required this.sentAt,
    @required this.readBy,
  })  : assert(from != null),
        assert(sentAt != null),
        assert(readBy != null);

  static String chatMessageTypeToString(ChatMessageType chatMessageType) {
    switch (chatMessageType) {
      case ChatMessageType.Text:
        return 'TEXT';
    }

    throw new Exception();
  }

  static ChatMessageType stringToChatMessageType(String chatMessageTypeString) {
    switch (chatMessageTypeString) {
      case 'TEXT':
        return ChatMessageType.Text;
    }

    throw new Exception();
  }
}

class DatabaseTextChatMessage extends DatabaseChatMessage implements TextChatMessage  {
  final String text;

  DatabaseTextChatMessage factory DatabaseTextChatMessage.fromDocument(DocumentSnapshot document, { @required UserReference from, @required DateTime sentAt, @required List<UserReference> readBy, }) {
    final maybeText = document.data['text'];

    assert(maybeText is String);
    assert(maybeText != null);

    return DatabaseTextChatMessage._(
      from: from,
      sentAt: sentAt,
      readBy: readBy,
      text: maybeText,
    );
  }

  DatabaseTextChatMessage._({
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
}
