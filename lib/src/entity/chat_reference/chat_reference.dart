import 'package:caramel/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentReference;
import './firestore_chat_reference.dart';
import './synchronous_chat_reference.dart';

abstract class ChatReference {
  factory ChatReference.fromFirestoreDocumentReference(
          DocumentReference documentReference) =>
      FirestoreChatReference.fromDocumentReference(documentReference);

  factory ChatReference.fromChat(ChatStruct chat) =>
      SynchronousChatReference.fromChat(chat);

  Future<Chat> resolve();
}
