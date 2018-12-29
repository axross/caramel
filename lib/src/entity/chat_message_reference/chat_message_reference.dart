import 'package:caramel/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentReference;
import './firestore_chat_message_reference.dart';

abstract class ChatMessageReference {
  factory ChatMessageReference.fromFirestoreDocumentReference(
    DocumentReference documentReference,
  ) =>
      FirestoreChatMessageReference.fromDocumentReference(documentReference);

  Future<ChatMessage> resolve();
}
