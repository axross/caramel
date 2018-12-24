import 'package:caramel/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import './firestore_chat_message_repository_service.dart';

abstract class ChatMessageRepositoryService {
  factory ChatMessageRepositoryService.withFirestore({
    @required Firestore firestore,
  }) =>
      FirestoreChatMessageRepositoryService(firestore: firestore);

  Stream<List<ChatMessage>> subscribeChatMessages(Chat chat);

  Future<void> postText({
    @required String text,
    @required Chat chat,
    @required User user,
  });
}
