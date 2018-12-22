import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;
import 'package:meta/meta.dart';
import './chat.dart';
import './user_reference.dart';
import './database_user_reference.dart';

class DatabaseChat implements Chat {
  final String id;
  final List<UserReference> members;

  DatabaseChat factory DatabaseChat.fromDocument(DocumentSnapshot document) {
    final id = document.documentID;
    final maybeMembers = document.data['members'];

    assert(maybeMembers is List);

    final members = (maybeMembers as List).map((maybeMember) => DatabaseUserReference.fromDocumentReference(maybeMember)).toList();

    return DatabaseChat._(id: id, members: members);
  }

  DatabaseChat._({@required this.id, @required this.members})
      : assert(id != null),
        assert(members != null);
}
