import 'package:caramel/entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentReference;

class FirestoreChatReference implements ChatReference {
  FirestoreChatReference.fromDocumentReference(
    DocumentReference documentReference,
  )   : assert(documentReference != null),
        _documentReference = documentReference;

  final DocumentReference _documentReference;

  Future<Chat> resolve() async {
    final document = await _documentReference.get();

    return Chat.fromFirestoreDocument(document);
  }
}
