import 'package:cloud_firestore/cloud_firestore.dart' show DocumentReference;
import './user_reference.dart';
import './database_user.dart';

class DatabaseUserReference implements UserReference {
  final DocumentReference _documentReference;

  DatabaseUserReference.fromDocumentReference(
    DocumentReference documentReference,
  )   : assert(documentReference != null),
        _documentReference = documentReference;

  Future<User> resolve() async {
    final document = await _documentReference.get();

    return DatabaseUser.fromDocument(document);
  }

  bool isSameUser(User user) => user.uid == _documentReference.documentID;

  bool operator ==(Object other) =>
      other is UserReference && other.hashCode == hashCode;

  int get hashCode => _documentReference.hashCode;
}
