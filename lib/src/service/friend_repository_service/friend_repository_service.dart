import 'package:caramel/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import './firestore_friend_repository_service.dart';

abstract class FriendRepositoryService {
  factory FriendRepositoryService.withFirestore({
    @required Firestore firestore,
  }) =>
      FirestoreFriendRepositoryService(firestore: firestore);

  Stream<List<Friendship>> subscribeFriendships(User user);
  Future<void> addByFriendCode(User user, FriendCode friendCode);
  Future<void> delete(User user, User friend);
}
