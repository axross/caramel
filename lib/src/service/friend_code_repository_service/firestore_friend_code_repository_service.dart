import 'package:caramel/entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import './friend_code_repository_service.dart';

class FirestoreFriendCodeRepositoryService
    implements FriendCodeRepositoryService {
  FirestoreFriendCodeRepositoryService({@required Firestore firestore})
      : assert(firestore != null),
        _firestore = firestore;

  final Firestore _firestore;

  Stream<FriendCode> subscribeNewestFriendCode(User me) => _firestore
          .collection('friendCodes')
          .where('user', isEqualTo: _firestore.document('users/${me.uid}'))
          .orderBy('issuedAt', descending: true)
          .limit(1)
          .snapshots()
          .map(
        (snapshot) {
          final friendCode = snapshot.documents.length == 0
              ? null
              : FriendCode.fromFirestoreDocument(snapshot.documents.first);

          if (friendCode == null) {
            issue(me);
          }

          return friendCode;
        },
      );

  Future<void> issue(User me) =>
      _firestore.collection('friendCodes').document().setData({
        'user': _firestore.document('/users/${me.uid}'),
        // TODO: replace with FieldValueType.serverTimestamp.
        // this API is available later than v0.8
        'issuedAt': DateTime.now(),
      });
}