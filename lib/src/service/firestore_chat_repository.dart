import 'package:caramel/domains.dart';
import 'package:caramel/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class FirestoreChatRepository implements ChatRepository {
  FirestoreChatRepository(Firestore firestore)
      : assert(firestore != null),
        _firestore = firestore;

  Firestore _firestore;

  @override
  Stream<List<Chat>> subscribeChats({
    @required SignedInUser hero,
  }) =>
      _firestore
          .collection('chats')
          .where(
            'members',
            arrayContains: _firestore.document('users/${hero.id}'),
          )
          .orderBy('lastMessageCreatedAt', descending: true)
          .snapshots()
          .map((query) => query.documents
              .map((document) => FirestoreChat(document))
              .toList());

  @override
  ChatReference referChatById({@required String id}) =>
      FirestoreChatReference(_firestore.collection('chats').document(id));

  @override
  Future<void> postTextToChat({
    @required SignedInUser hero,
    @required ChatReference chat,
    @required String text,
  }) =>
      _firestore.collection('chats/${chat.id}/messages').document().setData({
        'type': 'TEXT',
        'from': _firestore.document('users/${hero.id}'),
        'sentAt': FieldValue.serverTimestamp(),
        'text': text,
      });
}

class FirestoreChat with Entity, IdentifiableById<Chat> implements Chat {
  factory FirestoreChat(DocumentSnapshot document) {
    final id = document.documentID;
    final maybeParticipantReferences = document.data['members'];
    final maybeLastChatMessageReference = document.data['lastChatMessage'];
    final chatMessagesReference = document.reference.collection('messages');

    assert(maybeParticipantReferences is List);
    assert(maybeLastChatMessageReference == null ||
        maybeLastChatMessageReference is DocumentReference);

    final List<DocumentReference> list = List.from(maybeParticipantReferences);

    final participants = StatefulFuture(Future.wait(list.map(
        (ref) => ref.get().then((document) => FirestoreOtherUser(document)))));
    final lastChatMessage = maybeLastChatMessageReference == null
        ? null
        : FirestoreChatMessageReference(maybeLastChatMessageReference);
    final chatMessages = StatefulStream(chatMessagesReference.snapshots().map(
        (snapshot) => snapshot.documents
            .map((document) => FirestoreChatMessage(document))
            .toList()));

    return FirestoreChat._(
      id: id,
      participants: participants,
      lastChatMessage: lastChatMessage,
      chatMessages: chatMessages,
    );
  }

  FirestoreChat._({
    @required this.id,
    @required this.participants,
    @required this.lastChatMessage,
    @required this.chatMessages,
  })  : assert(id != null),
        assert(participants != null),
        assert(chatMessages != null);

  @override
  final String id;

  @override
  final StatefulFuture<List<User>> participants;

  @override
  final ChatMessageReference lastChatMessage;

  @override
  final StatefulStream<List<ChatMessage>> chatMessages;
}

class FirestoreChatReference extends StatefulFuture<Chat>
    with ReferenceEntity, IdentifiableBySubstanceId<ChatReference, Chat>
    implements ChatReference {
  FirestoreChatReference(DocumentReference documentReference)
      : assert(documentReference != null),
        id = documentReference.documentID,
        super(documentReference
            .get()
            .then((document) => FirestoreChat(document)));

  @override
  final String id;
}

class FirestoreChatMessage
    with Entity, IdentifiableById<ChatMessage>
    implements ChatMessage {
  factory FirestoreChatMessage(DocumentSnapshot document) {
    final maybeSender = document.data['from'];
    final maybeSentAt = document.data['sentAt'];
    final maybeType = document.data['type'];

    assert(maybeSender is DocumentReference);
    assert(maybeSender != null);
    assert(maybeSentAt == null || maybeSentAt is DateTime);
    assert(maybeType is String);
    assert(maybeType != null);

    final sender = FirestoreOtherUserReference(maybeSender);
    final sentAt = maybeSentAt ?? DateTime.now();
    final readBy = StatefulStream(document.reference
        .collection('readers')
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((document) => FirestoreOtherUser(document))
            .toList()));
    final String type = maybeType;

    switch (type) {
      case 'TEXT':
        return _FirestoreTextChatMessage(
          id: document.documentID,
          sender: sender,
          sentAt: sentAt,
          readBy: readBy,
          document: document,
        );
    }

    throw Exception();
  }

  FirestoreChatMessage._({
    @required this.id,
    @required this.sender,
    @required this.sentAt,
    @required this.readBy,
  })  : assert(id != null),
        assert(sender != null),
        assert(sentAt != null),
        assert(readBy != null);

  @override
  final String id;

  @override
  final UserReference sender;

  @override
  final DateTime sentAt;

  @override
  final StatefulStream<List<User>> readBy;
}

class _FirestoreTextChatMessage extends FirestoreChatMessage
    implements TextChatMessage {
  factory _FirestoreTextChatMessage({
    @required DocumentSnapshot document,
    @required String id,
    @required UserReference sender,
    @required DateTime sentAt,
    @required StatefulStream<List<User>> readBy,
  }) {
    final maybeBody = document.data['text'];

    assert(maybeBody is String);
    assert(maybeBody != null);

    return _FirestoreTextChatMessage._(
      id: id,
      sender: sender,
      sentAt: sentAt,
      readBy: readBy,
      body: maybeBody,
    );
  }

  _FirestoreTextChatMessage._({
    @required String id,
    @required UserReference sender,
    @required DateTime sentAt,
    @required StatefulStream<List<User>> readBy,
    @required this.body,
  })  : assert(body != null),
        super._(
          id: id,
          sender: sender,
          sentAt: sentAt,
          readBy: readBy,
        );

  @override
  final String body;
}

class FirestoreChatMessageReference extends StatefulFuture<ChatMessage>
    with
        ReferenceEntity,
        IdentifiableBySubstanceId<ChatMessageReference, ChatMessage>
    implements ChatMessageReference {
  FirestoreChatMessageReference(DocumentReference documentReference)
      : assert(documentReference != null),
        id = documentReference.documentID,
        super(documentReference
            .get()
            .then((document) => FirestoreChatMessage(document)));

  @override
  final String id;
}
