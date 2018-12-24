import 'package:caramel/entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentReference;
import './firestore_chat_reference.dart';

abstract class ChatReference {
  ChatReference factory ChatReference.fromFirestoreDocumentReference(DocumentReference documentReference) => FirestoreChatReference.fromDocumentReference(documentReference);

  Future<Chat> resolve();
}
