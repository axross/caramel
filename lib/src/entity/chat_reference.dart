import 'package:caramel/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentReference;
import 'package:meta/meta.dart';

/// A reference to [Chat].
@immutable
abstract class ChatReference {
  /// Creates a [ChatReference] from an actual [Chat].
  factory ChatReference.fromChat(Chat chat) =>
      _SynchronousChatReference.fromChat(chat);

  /// Creates a [ChatReference] from a Firebase [DocumentReference].
  factory ChatReference.fromFirestoreDocumentReference(
          DocumentReference documentReference) =>
      _FirestoreChatReference.fromDocumentReference(documentReference);

  /// Obtains [Chat].
  Future<Chat> resolve();
}

@immutable
class _SynchronousChatReference implements ChatReference {
  const _SynchronousChatReference.fromChat(
    Chat chat,
  )   : assert(chat != null),
        _chat = chat;

  final Chat _chat;

  @override
  Future<Chat> resolve() => Future.value(_chat);
}

@immutable
class _FirestoreChatReference implements ChatReference {
  const _FirestoreChatReference.fromDocumentReference(
    DocumentReference documentReference,
  )   : assert(documentReference != null),
        _documentReference = documentReference;

  final DocumentReference _documentReference;

  @override
  Future<Chat> resolve() async {
    final document = await _documentReference.get();

    return Chat.fromFirestoreDocument(document);
  }
}
