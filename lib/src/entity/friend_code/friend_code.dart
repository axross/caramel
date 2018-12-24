import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;
import './firestore_friend_code.dart';
import './parsed_friend_code.dart';

abstract class FriendCode {
  FriendCode(this.code) : assert(code != null);

  FriendCode factory FriendCode.fromFirestoreDocument(DocumentSnapshot document) => FirestoreFriendCode.fromDocument(document);
  FriendCode factory FriendCode.parse(String string) => ParsedFriendCode.parse(string);

  final String code;
}
