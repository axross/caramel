import 'package:caramel/entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import './firestore_friend_code_repository_service.dart';

abstract class FriendCodeRepositoryService {
  factory FriendCodeRepositoryService.withFirestore({
    @required Firestore firestore,
  }) =>
      FirestoreFriendCodeRepositoryService(firestore: firestore);

  Stream<FriendCode> subscribeNewestFriendCode(User me);
  Future<void> issue(User me);
}
