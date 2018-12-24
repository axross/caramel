import 'package:caramel/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import './friend_repository_service.dart';

class FirestoreFriendRepositoryService implements FriendRepositoryService {
  FirestoreFriendRepositoryService({@required Firestore firestore})
      : assert(firestore != null),
        _firestore = firestore;

  final Firestore _firestore;

  Stream<Iterable<Friendship>> subscribeFriendships(User user) => _firestore
      .collection('users/${user.uid}/friendships')
      .limit(100)
      .snapshots()
      .asyncMap<Iterable<Friendship>>(
        (snapshot) async => snapshot.documents
            .map((document) => Friendship.fromFirestoreDocument(document)),
      );

  Future<void> addByFriendCode(User user, FriendCode friendCode) async {
    final friendCodeDocument =
        await _firestore.document('friendCodes/${friendCode.code}').get();

    try {
      assert(friendCodeDocument.exists);
      assert(friendCodeDocument.data['user'] is DocumentReference);
    } catch (error) {
      throw new Exception();
    }

    final opponentDoc = await friendCodeDocument.data['user'].get();
    final opponent = User.fromFirestoreDocument(opponentDoc);

    await _firestore
        .document('users/${user.uid}/friendships/${opponent.uid}')
        .setData({
      'user': _firestore.document('users/${opponent.uid}'),
    });
  }

  Future<void> delete(User user, User friend) async {
    final friendDocumentReference =
        _firestore.document('users/${user.uid}/friendships/${friend.uid}');
    final friendshipDocument = await friendDocumentReference.get();

    try {
      assert(friendshipDocument.exists);
      assert(friendshipDocument.data['user'] is DocumentReference);
    } catch (error) {
      throw new Exception();
    }

    await friendDocumentReference.delete();
  }
}
