import 'package:caramel/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;

class FirestoreFriendCode implements FriendCode {
  FirestoreFriendCode._(this.code) : assert(code != null);

  FirestoreFriendCode factory FirestoreFriendCode.fromDocument(
      DocumentSnapshot documentSnapshot) {
    final code = documentSnapshot.documentID;

    return FirestoreFriendCode._(code);
  }

  final String code;
}
