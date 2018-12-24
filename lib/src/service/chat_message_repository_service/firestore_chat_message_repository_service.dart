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
    _firestore.collection('chats/${chat.id}/messages').document().setData({
      'type': 'TEXT',
      'from': _firestore.document('users/${user.uid}'),
      'sentAt': FieldValueType.serverTimestamp,
      'readBy': [],
      'text': text,
    });
  }
}
