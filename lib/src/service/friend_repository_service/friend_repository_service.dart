import 'package:caramel/entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import './firestore_friend_repository_service.dart';

abstract class FriendRepositoryService {
  factory FriendRepositoryService.withFirestore({
    @required Firestore firestore,
  }) =>
      FirestoreFriendRepositoryService(firestore: firestore);

  Stream<List<Friendship>> subscribeFriendships(User me);
  Future<void> addByFriendCode(User me, FriendCode friendCode);
  Future<void> delete(User me, User friend);
}
