import 'package:caramel/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentReference;
import './firestore_user_reference.dart';

abstract class UserReference {
  UserReference factory UserReference.fromFirestoreDocumentReference(DocumentReference documentReference) => FirestoreUserReference.fromDocumentReference(documentReference);

  Future<User> resolve();

  bool isSameUser(User user);

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;
}
