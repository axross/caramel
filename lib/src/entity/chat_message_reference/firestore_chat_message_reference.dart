import 'package:caramel/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentReference;

class FirestoreChatMessageReference implements ChatMessageReference {
  FirestoreChatMessageReference.fromDocumentReference(
    DocumentReference documentReference,
  )   : assert(documentReference != null),
        _documentReference = documentReference;

  final DocumentReference _documentReference;

  @override
  Future<ChatMessage> resolve() async {
    final document = await _documentReference.get();

    return ChatMessage.fromFirestoreDocument(document);
  }
}
