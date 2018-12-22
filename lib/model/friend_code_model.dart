import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import '../entity/database_friend_code.dart';
import '../entity/friend_code.dart';
import '../entity/user.dart';

class FriendCodeModel {
  final Firestore _database;
  final User _user;
  FriendCode _friendCode;

  FriendCodeModel(User user, {@required Firestore database})
      : _database = database,
        _user = user;

  Stream<FriendCode> get onChanged => _database
          .collection('friendCodes')
          .where('user', isEqualTo: _database.document('users/${_user.uid}'))
          .orderBy('issuedAt', descending: true)
          .limit(1)
          .snapshots()
          .map(
        (snapshot) {
          final friendCode = snapshot.documents.length == 0
              ? null
              : DatabaseFriendCode.fromDocument(snapshot.documents.first);

          if (friendCode == null) {
            _issueNewFriendCode();
          }

          _friendCode = friendCode;

          return friendCode;
        },
      );

  FriendCode get friendCode => _friendCode;

  Future<void> _issueNewFriendCode() async {
    await _database.collection('friendCodes').document().setData({
      'user': _database.document('/users/${_user.uid}'),
      'issuedAt': DateTime.now(),
    });
  }
}
