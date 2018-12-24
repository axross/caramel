import 'package:caramel/entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import './friend_repository_service.dart';

class FirestoreFriendRepositoryService implements FriendRepositoryService {
  FirestoreFriendRepositoryService({@required Firestore firestore})
      : assert(firestore != null),
        _firestore = firestore;

  final Firestore _firestore;

  Stream<List<Friendship>> subscribeFriendships(User me) => _firestore
      .collection('users/${me.uid}/friendships')
      .limit(100)
      .snapshots()
      .asyncMap<List<Friendship>>(
        (snapshot) async => snapshot.documents
            .map((document) => Friendship.fromFirestoreDocument(document))
            .toList(),
      );

  Future<void> addByFriendCode(User me, FriendCode friendCode) async {
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

    final batch = _firestore.batch();
    final chatDocumentReference = _firestore.collection('chats').document();

    batch.setData(
      _firestore.document('users/${me.uid}/friendships/${opponent.uid}'),
      {
        'user': _firestore.document('users/${opponent.uid}'),
        'chat': chatDocumentReference,
      },
    );

    batch.setData(chatDocumentReference, {
      'members': [
        _firestore.document('users/${me.uid}'),
        _firestore.document('users/${opponent.uid}'),
      ],
    });

    await batch.commit();
  }

  Future<void> delete(User me, User friend) async {
    final friendDocumentReference =
        _firestore.document('users/${me.uid}/friendships/${friend.uid}');
    final friendshipDocument = await friendDocumentReference.get();

    try {
      assert(friendshipDocument.exists);
      assert(friendshipDocument.data['user'] is DocumentReference);
      assert(friendshipDocument.data['chat'] is DocumentReference);
    } catch (error) {
      throw new Exception();
    }

    final batch = _firestore.batch();

    batch.delete(friendshipDocument.data['chat']);
    batch.delete(friendDocumentReference);

    await batch.commit();
  }
}
