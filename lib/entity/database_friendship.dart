import 'package:cloud_firestore/cloud_firestore.dart' show DocumentReference, DocumentSnapshot;
import 'package:meta/meta.dart';
import './chat_reference.dart';
import './database_user_reference.dart';
import './database_chat_reference.dart';
import './friendship.dart';
import './user_reference.dart';

class DatabaseFriendship implements Friendship {
  final UserReference user;
  final ChatReference chat;

  DatabaseFriendship factory DatabaseFriendship.fromDocument( DocumentSnapshot document) {
    final maybeUser = document.data['user'];
    final maybeChat = document.data['chat'];

    assert(maybeUser is DocumentReference);
    assert(maybeChat is DocumentReference);

    return DatabaseFriendship._(user: DatabaseUserReference.fromDocumentReference(maybeUser), chat: DatabaseChatReference.fromDocumentReference(maybeChat),);
  }

  DatabaseFriendship._({
    @required this.user,
    @required this.chat,
  })  : assert(user != null),
        assert(chat != null);
}
