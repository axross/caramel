import 'package:caramel/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart'
    show FieldValue, Firestore;
import 'package:meta/meta.dart';

/// A repository service of friend code.
abstract class FriendCodeRepositoryService {
  /// Creates a [FriendCodeRepositoryService] with a [Firestore].
  factory FriendCodeRepositoryService.withFirestore({
    @required Firestore firestore,
  }) =>
      _FirestoreFriendCodeRepositoryService(firestore: firestore);

  /// Subscribes the changes of the newest [FriendCode] of the [user].
  Stream<FriendCode> subscribeNewestFriendCode(User user);

  /// Issues a new [FriendCode].
  Future<void> issue(User user);
}

class _FirestoreFriendCodeRepositoryService
    implements FriendCodeRepositoryService {
  _FirestoreFriendCodeRepositoryService({@required Firestore firestore})
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
