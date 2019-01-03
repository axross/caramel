import 'package:caramel/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentReference;
import 'package:meta/meta.dart';

/// A reference to [ChatMessage].
@immutable
abstract class ChatMessageReference {
  /// Creates [ChatMessageReference] from a Firestore [DocumentReference].
  factory ChatMessageReference.fromFirestoreDocumentReference(
    DocumentReference documentReference,
  ) =>
      _FirestoreChatMessageReference.fromDocumentReference(documentReference);

  /// Obtains [ChatMessage].
  Future<ChatMessage> resolve();
}

@immutable
class _FirestoreChatMessageReference implements ChatMessageReference {
  const _FirestoreChatMessageReference.fromDocumentReference(
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
