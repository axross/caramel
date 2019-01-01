import 'package:caramel/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import './friend_code_repository_service.dart';

class FirestoreFriendCodeRepositoryService
    implements FriendCodeRepositoryService {
  FirestoreFriendCodeRepositoryService({@required Firestore firestore})
      : assert(firestore != null),
        _firestore = firestore;

  final Firestore _firestore;

  @override
  Stream<FriendCode> subscribeNewestFriendCode(User user) => _firestore
          .collection('friendCodes')
          .where('user', isEqualTo: _firestore.document('users/${user.uid}'))
          .orderBy('issuedAt', descending: true)
          .limit(1)
          .snapshots()
          .map(
        (snapshot) {
          final friendCode = snapshot.documents.isEmpty
              ? null
              : FriendCode.fromFirestoreDocument(snapshot.documents.first);

          if (friendCode == null) {
            issue(user);
          }

          return friendCode;
        },
      );

  @override
  Future<void> issue(User user) =>
      _firestore.collection('friendCodes').document().setData({
        'user': _firestore.document('/users/${user.uid}'),
        'issuedAt': FieldValue.serverTimestamp(),
      });
}
