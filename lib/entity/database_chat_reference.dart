import 'package:cloud_firestore/cloud_firestore.dart' show DocumentReference;
import './chat.dart';
import './chat_reference.dart';
import './database_chat.dart';

class DatabaseChatReference implements ChatReference {
  final DocumentReference _documentReference;

  DatabaseChatReference.fromDocumentReference(
    DocumentReference documentReference,
  )   : assert(documentReference != null),
        _documentReference = documentReference;

  Future<Chat> resolve() async {
    final document = await _documentReference.get();

    return DatabaseChat.fromDocument(document);
  }
}
