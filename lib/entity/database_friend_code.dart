import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;
import './friend_code.dart';

class DatabaseFriendCode implements FriendCode {
  final String code;

  DatabaseFriendCode._(this.code) : assert(code != null);

  DatabaseFriendCode factory DatabaseFriendCode.fromDocumentSnapshot(
      DocumentSnapshot documentSnapshot) {
    final code = documentSnapshot.documentID;

    return DatabaseFriendCode._(code);
  }
}
