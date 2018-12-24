import 'package:caramel/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;
import 'package:meta/meta.dart';
import './firestore_chat.dart';

abstract class Chat {
  final String id;
  final Iterable<UserReference> members;

  Chat({@required this.id, @required this.members})
      : assert(id != null),
        assert(members != null);
  
  Chat factory Chat.fromFirestoreDocument(DocumentSnapshot document) => FirestoreChat.fromDocument(document);
}
