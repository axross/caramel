import 'package:caramel/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;

class FirestoreFriendCode implements FriendCode {
  FirestoreFriendCode factory FirestoreFriendCode.fromDocument(
      DocumentSnapshot documentSnapshot) {
    final id = documentSnapshot.documentID;

    return FirestoreFriendCode._(id);
  }

  FirestoreFriendCode._(this.id) : assert(id != null);

  final String id;
  
  get code => id;
}
