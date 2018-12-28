import 'package:caramel/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show Firestore;
import 'package:meta/meta.dart';
import './firestore_chat_repository_service.dart';

abstract class ChatRepositoryService {
  ChatRepositoryService factory ChatRepositoryService.withFirestore({
    @required Firestore firestore,
  }) =>
      FirestoreChatRepositoryService(firestore: firestore);

  Stream<Iterable<Chat>> subscribeChats(User user);
  Stream<Chat> subscribeChatByFriendship(User user, Friendship friendship);
  Future<void> createChat(User user, User friend);
}
