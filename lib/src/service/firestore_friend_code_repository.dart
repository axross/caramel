import 'package:caramel/domains.dart';
import 'package:caramel/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class FirestoreFriendCodeRepository implements FriendCodeRepository {
  FirestoreFriendCodeRepository(Firestore firestore) : _firestore = firestore;

  final Firestore _firestore;

  @override
  Stream<FirestoreFriendCode> subscribeNewestFriendCode({
    @required SignedInUser hero,
  }) =>
      _firestore
          .collection('friendCodes')
          .where(
            'user',
            isEqualTo: _firestore.collection('users').document(hero.id),
          )
          .orderBy('issuedAt', descending: true)
          .limit(1)
          .snapshots()
          .map((snapshot) => snapshot.documents.isEmpty
              ? null
              : FirestoreFriendCode(snapshot.documents.first));

  @override
  Future<void> create({
    @required SignedInUser hero,
  }) =>
      _firestore.collection('friendCodes').document().setData({
        'user': _firestore.document('/users/${hero.id}'),
        'issuedAt': FieldValue.serverTimestamp(),
      });

  @override
  Future<void> delete({
    @required FriendCode friendCode,
  }) =>
      _firestore.collection('friendCodes').document(friendCode.data).delete();
}

class FirestoreFriendCode implements FriendCode {
  factory FirestoreFriendCode(DocumentSnapshot document) {
    final id = document.documentID;

    return FirestoreFriendCode._(id);
  }

  FirestoreFriendCode._(String id)
      : assert(id != null),
        _id = id;

  final String _id;

  @override
  String get data => _id;

  @override
  bool operator ==(Object other) =>
      other is FirestoreFriendCode && other.hashCode == hashCode;

  @override
  int get hashCode => _id.hashCode;
}
