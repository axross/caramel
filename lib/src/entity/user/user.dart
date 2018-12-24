import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;
import 'package:meta/meta.dart';
import './firestore_user.dart';

abstract class User {
  User({@required this.uid, @required this.name, @required this.imageUrl})
      : assert(uid != null),
        assert(name != null),
        assert(imageUrl != null);
  
  User factory User.fromFirestoreDocument(DocumentSnapshot document) => FirestoreUser.fromDocument(document);

  final String uid;
  final String name;
  final Uri imageUrl;
}
