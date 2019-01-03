import 'package:caramel/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart'
    show DocumentReference, DocumentSnapshot;
import 'package:meta/meta.dart';

/// A chat room.
@immutable
abstract class Chat {
  /// Creates a [Chat] from a Firebase [DocumentSnapshot].
  factory Chat.fromFirestoreDocument(DocumentSnapshot document) =>
      _FirestoreChat.fromDocument(document);

  /// 消すかも
  @deprecated
  String get id;

  /// The users joined in the chat.
  Iterable<UserReference> get members;

  /// The last [ChatMessage] in the chat.
  ChatMessageReference get lastChatMessage;

  /// Returns [ChatReference] pointing this object.
  ChatReference toReference();
}

@immutable
class _FirestoreChat implements Chat {
  factory _FirestoreChat.fromDocument(DocumentSnapshot document) {
    final id = document.documentID;
    final maybeMembers = document.data['members'];
    final maybeLastChatMessage = document.data['lastChatMessage'];

    assert(maybeMembers is Iterable);
    assert(maybeLastChatMessage == null ||
        maybeLastChatMessage is DocumentReference);

    final Iterable membersAsIterable = maybeMembers;

    final members = membersAsIterable.map(
      (maybeMember) =>
          UserReference.fromFirestoreDocumentReference(maybeMember),
    );
    final lastChatMessage = maybeLastChatMessage == null
        ? null
        : ChatMessageReference.fromFirestoreDocumentReference(
            maybeLastChatMessage);

    return _FirestoreChat._(
      id: id,
      members: members,
      lastChatMessage: lastChatMessage,
    );
  }

  const _FirestoreChat._({
    @required this.id,
    @required this.members,
    this.lastChatMessage,
  })  : assert(id != null),
        assert(members != null);

  @override
  final String id;

  @override
  final Iterable<UserReference> members;

  @override
  final ChatMessageReference lastChatMessage;

  @override
  ChatReference toReference() => ChatReference.fromChat(this);
}
