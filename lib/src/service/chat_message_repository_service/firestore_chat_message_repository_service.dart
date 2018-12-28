import 'package:caramel/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import './chat_message_repository_service.dart';

class FirestoreChatMessageRepositoryService
    implements ChatMessageRepositoryService {
  FirestoreChatMessageRepositoryService({@required Firestore firestore})
      : assert(firestore != null),
        _firestore = firestore;

  final Firestore _firestore;

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

  Future<void> postText({
    @required String text,
    @required Chat chat,
    @required User user,
  }) async {
    // TODO: I can't implement this process like the below.
    // See: https://github.com/flutter/flutter/issues/24992
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
