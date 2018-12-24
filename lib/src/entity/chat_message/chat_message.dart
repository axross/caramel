import 'package:caramel/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;
import 'package:meta/meta.dart';
import './firestore_chat_message.dart';

abstract class ChatMessage {
  ChatMessage({
    @required this.from,
    @required this.sentAt,
    @required this.readBy,
  })  : assert(from != null),
        assert(sentAt != null),
        assert(readBy != null);

  ChatMessage factory ChatMessage.fromFirestoreDocument(DocumentSnapshot document) => FirestoreChatMessage.fromDocument(document);

  final UserReference from;
  final DateTime sentAt;
  final List<UserReference> readBy;
}

abstract class TextChatMessage extends ChatMessage {
  TextChatMessage({
    @required UserReference from,
    @required DateTime sentAt,
    @required List<UserReference> readBy,
    @required this.text,
  }) : super(from: from, sentAt: sentAt, readBy: readBy);

  final String text;
}
