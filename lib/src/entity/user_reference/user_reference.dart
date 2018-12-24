import 'package:caramel/entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentReference;
import './firestore_user_reference.dart';

abstract class UserReference {
  Future<User> resolve();
  bool isSameUser(User user);
  bool operator ==(Object other);
  int get hashCode;

  UserReference factory UserReference.fromFirestoreDocumentReference(DocumentReference documentReference) => FirestoreUserReference.fromDocumentReference(documentReference);
}
