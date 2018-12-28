import 'package:caramel/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentReference;

class FirestoreUserReference implements UserReference {
  FirestoreUserReference.fromDocumentReference(
    DocumentReference documentReference,
  )   : assert(documentReference != null),
        _documentReference = documentReference;

  final DocumentReference _documentReference;

  Future<User> resolve() async {
    final document = await _documentReference.get();

    return User.fromFirestoreDocument(document);
  }

  bool isSameUser(User user) => user.uid == _documentReference.documentID;

  @override
  bool operator ==(Object other) =>
      other is UserReference && other.hashCode == hashCode;

  @override
  int get hashCode => _documentReference.hashCode;
}
