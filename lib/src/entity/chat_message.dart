import 'package:caramel/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart'
    show DocumentReference, DocumentSnapshot;
import 'package:meta/meta.dart';

/// A message users posted in a chat.
@immutable
abstract class ChatMessage {
  /// Creates a [ChatMessage] from a Firebase [DocumentSnapshot].
  factory ChatMessage.fromFirestoreDocument(DocumentSnapshot document) =>
      _FirestoreChatMessage.fromDocument(document);

  /// The user who posted the message.
  UserReference get from;

  /// The [DateTime] when the message posted at.
  DateTime get sentAt;

  /// The users who has already read the message.
  Iterable<UserReference> get readBy;
}

/// A text message of [ChatMessage].
@immutable
abstract class TextChatMessage implements ChatMessage {
  @override
  UserReference get from;

  @override
  DateTime get sentAt;

  @override
  Iterable<UserReference> get readBy;

  /// The message body.
  String get text;
}

@immutable
abstract class _FirestoreChatMessage implements ChatMessage {
  factory _FirestoreChatMessage.fromDocument(DocumentSnapshot document) {
    final maybeFrom = document.data['from'];
    final maybeSentAt = document.data['sentAt'];
    final maybeReadBy = document.data['readBy'];
    final maybeType = document.data['type'];

    assert(maybeFrom is DocumentReference);
    assert(maybeFrom != null);
    assert(maybeSentAt == null || maybeSentAt is DateTime);
    assert(maybeReadBy is List);
    assert(maybeReadBy != null);
    assert(maybeType is String);
    assert(maybeType != null);

    final from = UserReference.fromFirestoreDocumentReference(maybeFrom);
    final List readByList = maybeReadBy;
    final readBy = readByList
        .map((maybeUserDocumentReference) =>
            UserReference.fromFirestoreDocumentReference(
                maybeUserDocumentReference))
        .toList();
    final sentAt = maybeSentAt == null ? DateTime.now() : maybeSentAt;

    switch (maybeType) {
      case 'TEXT':
        return _FirestoreTextChatMessage._fromDocument(
          document,
          from: from,
          sentAt: sentAt,
          readBy: readBy,
        );
        break;
    }

    throw Exception();
  }

  @override
  final UserReference from;

  @override
  final DateTime sentAt;

  @override
  final Iterable<UserReference> readBy;
}

@immutable
class _FirestoreTextChatMessage
    implements _FirestoreChatMessage, TextChatMessage {
  factory _FirestoreTextChatMessage._fromDocument(
    DocumentSnapshot document, {
    @required UserReference from,
    @required DateTime sentAt,
    @required Iterable<UserReference> readBy,
  }) {
    final maybeText = document.data['text'];

    assert(maybeText is String);
    assert(maybeText != null);

    return _FirestoreTextChatMessage._(
      from: from,
      sentAt: sentAt,
      readBy: readBy,
      text: maybeText,
    );
  }

  const _FirestoreTextChatMessage._({
    @required this.from,
    @required this.sentAt,
    @required this.readBy,
    @required this.text,
  })  : assert(from != null),
        assert(sentAt != null),
        assert(readBy != null),
        assert(text != null);

  @override
  final UserReference from;

  @override
  final DateTime sentAt;

  @override
  final Iterable<UserReference> readBy;

  @override
  final String text;
}
