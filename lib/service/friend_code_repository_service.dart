import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import '../entity/database_friend_code.dart';
import '../entity/friend_code.dart';
import '../entity/user.dart';

abstract class FriendCodeRepositoryService {
  factory FriendCodeRepositoryService({@required Firestore database}) {
    return _FirestoreFriendCodeRepositoryService(database: database);
  }

  Stream<FriendCode> subscribeNewestFriendCode(User me);
  Future<void> issue(User me);
}

class _FirestoreFriendCodeRepositoryService
    implements FriendCodeRepositoryService {
  final Firestore _database;

  _FirestoreFriendCodeRepositoryService({@required Firestore database})
      : assert(database != null),
        _database = database;

  Stream<FriendCode> subscribeNewestFriendCode(User me) => _database
          .collection('friendCodes')
          .where('user', isEqualTo: _database.document('users/${me.uid}'))
          .orderBy('issuedAt', descending: true)
          .limit(1)
          .snapshots()
          .map(
        (snapshot) {
          final friendCode = snapshot.documents.length == 0
              ? null
              : DatabaseFriendCode.fromDocument(snapshot.documents.first);

          if (friendCode == null) {
            issue(me);
          }

          return friendCode;
        },
      );

  Future<void> issue(User me) =>
      _database.collection('friendCodes').document().setData({
        'user': _database.document('/users/${me.uid}'),
        // TODO: replace with FieldValueType.serverTimestamp.
        // this API is available later than v0.8
        'issuedAt': DateTime.now(),
      });
}
