import 'package:caramel/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;
import 'package:meta/meta.dart';
import './firestore_friendship.dart';

abstract class Friendship {
  Friendship({
    @required this.user,
  })  : assert(user != null);

  Friendship factory Friendship.fromFirestoreDocument(DocumentSnapshot document) => FirestoreFriendship.fromDocument(document);

  final UserReference user;
}
