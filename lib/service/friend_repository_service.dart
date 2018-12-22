import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import '../entity/database_user.dart';
import '../entity/database_friendship.dart';
import '../entity/friendship.dart';
import '../entity/friend_code.dart';

abstract class FriendRepositoryService {
  factory FriendRepositoryService({@required Firestore database}) {
    return _FriendRepositoryServiceImpl(database: database);
  }

  Stream<List<Friendship>> subscribeFriendships(User me);
  Future<void> addByFriendCode(User me, FriendCode friendCode);
  Future<void> delete(User me, User friend);
}

class _FriendRepositoryServiceImpl implements FriendRepositoryService {
  final Firestore _database;

  _FriendRepositoryServiceImpl({@required Firestore database})
      : assert(database != null),
        _database = database;

  Stream<List<Friendship>> subscribeFriendships(User me) => _database
      .collection('users/${me.uid}/friendships')
      .limit(100)
      .snapshots()
      .asyncMap<List<Friendship>>(
        (snapshot) async => snapshot.documents
            .map((document) => DatabaseFriendship.fromDocument(document))
            .toList(),
      );

  Future<void> addByFriendCode(User me, FriendCode friendCode) async {
    final friendCodeDocument =
        await _database.document('friendCodes/${friendCode.code}').get();

    try {
      assert(friendCodeDocument.exists);
      assert(friendCodeDocument.data['user'] is DocumentReference);
    } catch (error) {
      throw new Exception();
    }

    final opponentDoc = await friendCodeDocument.data['user'].get();
    final opponent = DatabaseUser.fromDocument(opponentDoc);

    final batch = _database.batch();
    final chatDocumentReference = _database.collection('chats').document();

    batch.setData(
      _database.document('users/${me.uid}/friendships/${opponent.uid}'),
      {
        'user': _database.document('users/${opponent.uid}'),
        'chat': chatDocumentReference,
      },
    );

    batch.setData(chatDocumentReference, {
      'members': [
        _database.document('users/${me.uid}'),
        _database.document('users/${opponent.uid}'),
      ],
    });

    await batch.commit();
  }

  Future<void> delete(User me, User friend) async {
    final friendDocumentReference =
        _database.document('users/${me.uid}/friendships/${friend.uid}');
    final friendshipDocument = await friendDocumentReference.get();

    try {
      assert(friendshipDocument.exists);
      assert(friendshipDocument.data['user'] is DocumentReference);
      assert(friendshipDocument.data['chat'] is DocumentReference);
    } catch (error) {
      throw new Exception();
    }

    final batch = _database.batch();

    batch.delete(friendshipDocument.data['chat']);
    batch.delete(friendDocumentReference);

    await batch.commit();
  }
}
