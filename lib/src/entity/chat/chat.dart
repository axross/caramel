import 'package:caramel/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;
import './firestore_chat.dart';

mixin ChatStruct {
  String get id;
  Iterable<UserReference> get members;
  ChatMessageReference get lastChatMessage;
}

mixin ToReferenceMixin on ChatStruct {
  ChatReference toReference() => ChatReference.fromChat(this);
}

abstract class Chat with ChatStruct, ToReferenceMixin {
  factory Chat.fromFirestoreDocument(DocumentSnapshot document) =>
      FirestoreChat.fromDocument(document);

  String get id;
  Iterable<UserReference> get members;
  ChatMessageReference get lastChatMessage;
}
