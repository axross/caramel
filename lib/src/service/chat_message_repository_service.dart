import 'package:caramel/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart'
    show FieldValue, Firestore;
import 'package:meta/meta.dart';

/// A repository service of chats
abstract class ChatMessageRepositoryService {
  /// Creates a [ChatMessageRepositoryService] with a [Firestore].
  factory ChatMessageRepositoryService.withFirestore({
    @required Firestore firestore,
  }) =>
      _FirestoreChatMessageRepositoryService(firestore: firestore);

  /// Subscribes the changes of the list of [ChatMessage]s in the [chat].
  Stream<Iterable<ChatMessage>> subscribeChatMessages(Chat chat);

  /// Posts a [TextChatMessage].
  Future<void> postText({
    @required String text,
    @required Chat chat,
    @required User user,
  });
}

class _FirestoreChatMessageRepositoryService
    implements ChatMessageRepositoryService {
  _FirestoreChatMessageRepositoryService({@required Firestore firestore})
      : assert(firestore != null),
        _firestore = firestore;

  final Firestore _firestore;

  @override
  Stream<Iterable<ChatMessage>> subscribeChatMessages(Chat chat) => _firestore
      .collection('chats/${chat.id}/messages')
      .orderBy('sentAt', descending: true)
      .limit(100)
      .snapshots()
      .map(
        (query) => query.documents.map(
              (document) => ChatMessage.fromFirestoreDocument(document),
            ),
      );

  @override
  Future<void> postText({
    @required String text,
    @required Chat chat,
    @required User user,
  }) async {
    // TODO(axross): I can't implement this process like the below.
    // https://github.com/axross/caramel/issues/2
    //
    // final batch = _firestore.batch();
    // final chatMessageDocumentReference =
    //     _firestore.collection('chats/${chat.id}/messages').document();

    // batch.setData(chatMessageDocumentReference, {
    //   'type': 'TEXT',
    //   'from': _firestore.document('users/${user.uid}'),
    //   'sentAt': FieldValue.serverTimestamp(),
    //   'readBy': [],
    //   'text': text,
    // });

    // batch.updateData(_firestore.document('chats/${chat.id}'), {
    //   'lastChatMessage': chatMessageDocumentReference,
    // });

    // await batch.commit();

    final chatMessageDocumentReference =
        _firestore.collection('chats/${chat.id}/messages').document();

    await Future.wait([
      chatMessageDocumentReference.setData({
        'type': 'TEXT',
        'from': _firestore.document('users/${user.uid}'),
        'sentAt': FieldValue.serverTimestamp(),
        'readBy': [],
        'text': text,
      }),
      _firestore.document('chats/${chat.id}').updateData({
        'lastChatMessage': chatMessageDocumentReference,
        'lastMessageCreatedAt': FieldValue.serverTimestamp(),
      }),
    ]);
  }
}
