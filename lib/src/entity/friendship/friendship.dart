import 'package:caramel/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;
import './firestore_friendship.dart';

abstract class Friendship {
  Friendship factory Friendship.fromFirestoreDocument(DocumentSnapshot document) => FirestoreFriendship.fromDocument(document);

  UserReference get user;
}
