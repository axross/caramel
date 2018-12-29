import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;
import './firestore_user.dart';

abstract class User {
  factory User.fromFirestoreDocument(DocumentSnapshot document) =>
      FirestoreUser.fromDocument(document);

  String get uid;
  String get name;
  Uri get imageUrl;
}
