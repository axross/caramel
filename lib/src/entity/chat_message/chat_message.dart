import 'package:caramel/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;
import './firestore_chat_message.dart';

abstract class ChatMessage {
  factory ChatMessage.fromFirestoreDocument(DocumentSnapshot document) =>
      FirestoreChatMessage.fromDocument(document);

  UserReference get from;
  DateTime get sentAt;
  Iterable<UserReference> get readBy;
}

abstract class TextChatMessage implements ChatMessage {
  UserReference get from;
  DateTime get sentAt;
  Iterable<UserReference> get readBy;
  String get text;
}
