import 'package:caramel/entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import './chat_message_repository_service.dart';

class FirestoreChatMessageRepositoryService
    implements ChatMessageRepositoryService {
  FirestoreChatMessageRepositoryService({@required Firestore firestore})
      : assert(firestore != null),
        _firestore = firestore;

  final Firestore _firestore;

  Stream<List<ChatMessage>> subscribeChatMessages(Chat chat) => _firestore
      .collection('chats/${chat.id}/messages')
      .orderBy('sentAt', descending: true)
      .limit(100)
      .snapshots()
      .map(
        (query) => query.documents
            .map((document) => ChatMessage.fromFirestoreDocument(document))
            .toList(),
      );

  Future<void> postText({
    @required String text,
    @required Chat chat,
    @required User me,
  }) async {
    _firestore.collection('chats/${chat.id}/messages').document().setData({
      'type': 'TEXT',
      'from': _firestore.document('users/${me.uid}'),
      'sentAt': DateTime.now(),
      'readBy': [],
      'text': text,
    });
  }
}
