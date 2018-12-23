import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import '../entity/chat.dart';
import '../entity/chat_message.dart';
import '../entity/database_chat_message.dart';
import '../entity/user.dart';

abstract class ChatMessageRepositoryService {
  factory ChatMessageRepositoryService({@required Firestore database}) =>
      _FirestoreChatMessageRepositoryService(database: database);

  Stream<List<ChatMessage>> subscribeChatMessages(Chat chat);

  Future<void> postText({
    @required String text,
    @required Chat chat,
    @required User me,
  });
}

class _FirestoreChatMessageRepositoryService
    implements ChatMessageRepositoryService {
  final Firestore _database;

  _FirestoreChatMessageRepositoryService({@required Firestore database})
      : assert(database != null),
        _database = database;

  Stream<List<ChatMessage>> subscribeChatMessages(Chat chat) => _database
      .collection('chats/${chat.id}/messages')
      .orderBy('sentAt', descending: true)
      .limit(100)
      .snapshots()
      .map(
        (query) => query.documents
            .map((document) => DatabaseChatMessage.fromDocument(document))
            .toList(),
      );

  Future<void> postText({
    @required String text,
    @required Chat chat,
    @required User me,
  }) async {
    _database.collection('chats/${chat.id}/messages').document().setData({
      'type': DatabaseChatMessage.chatMessageTypeToString(ChatMessageType.Text),
      'from': _database.document('users/${me.uid}'),
      'sentAt': DateTime.now(),
      'readBy': [],
      'text': text,
    });
  }
}
