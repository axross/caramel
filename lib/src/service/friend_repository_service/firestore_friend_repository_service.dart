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

    final friendDocument = await friendCodeDocument.data['user'].get();
    final friend = User.fromFirestoreDocument(friendDocument);

    final chatDocuments = await Future.wait([
      _firestore.collection('chats').where('members', isEqualTo: [
        _firestore.document('users/${user.uid}'),
        _firestore.document('users/${friend.uid}'),
      ]).getDocuments(),
      _firestore.collection('chats').where('members', isEqualTo: [
        _firestore.document('users/${friend.uid}'),
        _firestore.document('users/${user.uid}'),
      ]).getDocuments(),
    ])
        .then((snapshots) => snapshots.fold<List<DocumentSnapshot>>(
            [], (list, snapshot) => list..addAll(snapshot.documents)))
        .then((documents) => documents.where((document) => document != null));

    final batch = _firestore.batch();

    batch.setData(
        _firestore.document('users/${user.uid}/friendships/${friend.uid}'), {
      'user': _firestore.document('users/${friend.uid}'),
    });

    if (chatDocuments.length == 0) {
      batch.setData(_firestore.collection('chats').document(), {
        'members': [
          _firestore.document('users/${user.uid}'),
          _firestore.document('users/${friend.uid}'),
        ],
        'lastChatMessage': null,
      });
    }

    await batch.commit();
  }

  Future<void> delete(User user, User friend) async {
    // TODO: Unfollowing both of them should also delete chat document.

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
