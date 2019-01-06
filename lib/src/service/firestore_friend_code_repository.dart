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
          .where('user', isEqualTo: _firestore.document('users/${hero.id}'))
          .orderBy('issuedAt', descending: true)
          .limit(1)
          .snapshots()
          .map(
            (snapshot) => snapshot.documents.isEmpty
                ? null
                : FirestoreFriendCode(snapshot.documents.first),
          );

  @override
  Future<void> create({
    @required SignedInUser hero,
    AtomicWrite atomicWrite,
  }) async {
    final friendCodeRef = _firestore.collection('friendCodes').document();
    final data = {
      'user': _firestore.document('/users/${hero.id}'),
      'issuedAt': FieldValue.serverTimestamp(),
    };

    if (atomicWrite == null) {
      await friendCodeRef.setData(data);
    } else {
      atomicWrite.forFirestore.setData(friendCodeRef, data);
    }
  }

  @override
  Future<void> delete({
    @required FriendCode friendCode,
    AtomicWrite atomicWrite,
  }) async {
    final friendCodeRef =
        _firestore.collection('friendCodes').document(friendCode.data);

    if (atomicWrite == null) {
      await friendCodeRef.delete();
    } else {
      atomicWrite.forFirestore.delete(friendCodeRef);
    }
  }
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
