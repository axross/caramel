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
  Stream<Iterable<Chat>> subscribeChats({
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
          .map((query) =>
              query.documents.map((document) => FirestoreChat(document)));

  @override
  Future<Chat> getChatById({
    @required String chatId,
  }) =>
      _firestore
          .document('chats/$chatId')
          .get()
          .then((document) => FirestoreChat(document));

  @override
  Future<Chat> findOneOnOneChat({
    @required SignedInUser hero,
    @required User opponent,
  }) =>
      Future.wait([
        _firestore
            .collection('chats')
            .where('members', isEqualTo: [
              _firestore.document('users/${hero.id}'),
              _firestore.document('users/${opponent.id}'),
            ])
            .limit(1)
            .getDocuments(),
        _firestore
            .collection('chats')
            .where('members', isEqualTo: [
              _firestore.document('users/${opponent.id}'),
              _firestore.document('users/${hero.id}'),
            ])
            .limit(1)
            .getDocuments(),
      ]).then(
        (snapshots) => FirestoreChat(snapshots
            .firstWhere((snapshot) => snapshot.documents.isNotEmpty)
            .documents
            .first),
      );

  @override
  Future<void> createOneOnOneChat({
    @required SignedInUser hero,
    @required User opponent,
  }) =>
      _firestore.collection('chats').document().setData({
        'members': [
          _firestore.document('users/${hero.id}'),
          _firestore.document('users/${opponent.id}'),
        ],
        'lastMessageCreatedAt': null,
        'lastChatMessage': null,
      });

  @override
  Future<void> postTextToChat({
    @required SignedInUser hero,
    @required Chat chat,
    @required String text,
  }) async {
    // TODO(axross): I can't implement this process like the below.
    // https://github.com/axross/caramel/issues/2
    //
    // final batch = _firestore.batch();
    // final chatMessageDocumentReference =
    //     _firestore.collection('chats/${chat.id}/messages').document();

    // batch.setData(chatMessageDocumentReference, {
    //   'type': 'TEXT',
    //   'from': _firestore.document('users/${user.uid}'),
    //   'sentAt': FieldValue.serverTimestamp(),
    //   'readBy': [],
    //   'text': text,
    // });

    // batch.updateData(_firestore.document('chats/${chat.id}'), {
    //   'lastChatMessage': chatMessageDocumentReference,
    // });

    // await batch.commit();

    final chatMessageDocumentReference =
        _firestore.collection('chats/${chat.id}/messages').document();

    await Future.wait([
      chatMessageDocumentReference.setData({
        'type': 'TEXT',
        'from': _firestore.document('users/${hero.id}'),
        'sentAt': FieldValue.serverTimestamp(),
        'readBy': [],
        'text': text,
      }),
      _firestore.document('chats/${chat.id}').updateData({
        'lastChatMessage': chatMessageDocumentReference,
        'lastMessageCreatedAt': FieldValue.serverTimestamp(),
      }),
    ]);
  }
}

class FirestoreChat with IdentifiableById<Chat> implements Chat {
  factory FirestoreChat(DocumentSnapshot document) {
    final id = document.documentID;
    final maybeParticipantReferences = document.data['members'];
    final maybeLastChatMessageReference = document.data['lastChatMessage'];
    final chatMessagesReference = document.reference.collection('messages');

    assert(maybeParticipantReferences is List);
    assert(maybeLastChatMessageReference == null ||
        maybeLastChatMessageReference is DocumentReference);

    final List<DocumentReference> list = List.from(maybeParticipantReferences);

    final participants = FirestoreUsersReference.fromDocumentReferences(
      list,
    );
    final lastChatMessage = maybeLastChatMessageReference == null
        ? null
        : FirestoreChatMessageReference(maybeLastChatMessageReference);
    final chatMessages =
        FirestoreChatMessagesObservable.fromCollectionReferences(
      chatMessagesReference,
    );

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
  final UsersReference participants;

  @override
  final ChatMessageReference lastChatMessage;

  @override
  final ChatMessagesObservable chatMessages;
}

class FirestoreChatReference
    with IdentifiableBySubstanceId<ChatReference, Chat>
    implements ChatReference {
  FirestoreChatReference(DocumentReference documentReference)
      : assert(documentReference != null),
        _documentReference = documentReference;

  @override
  String get substanceId => _documentReference.documentID;

  final DocumentReference _documentReference;

  @override
  Future<Chat> get resolve =>
      _documentReference.get().then((document) => FirestoreChat(document))
        ..then((chat) {
          _chat = chat;
        });

  Chat _chat;

  @override
  Chat get value => _chat;
}

class FirestoreChatMessage
    with IdentifiableById<ChatMessage>
    implements ChatMessage {
  factory FirestoreChatMessage(DocumentSnapshot document) {
    final maybeSender = document.data['from'];
    final maybeSentAt = document.data['sentAt'];
    final maybeReadBy = document.data['readBy'];
    final maybeType = document.data['type'];

    assert(maybeSender is DocumentReference);
    assert(maybeSender != null);
    assert(maybeSentAt == null || maybeSentAt is DateTime);
    assert(maybeReadBy is List);
    assert(maybeReadBy != null);
    assert(maybeType is String);
    assert(maybeType != null);

    final sender = FirestoreUserReference(maybeSender);
    final sentAt = maybeSentAt ?? DateTime.now();
    final List<DocumentReference> list = List.from(maybeReadBy);
    final readBy = FirestoreUsersReference.fromDocumentReferences(list);
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
  final UsersReference readBy;
}

class _FirestoreTextChatMessage extends FirestoreChatMessage
    implements TextChatMessage {
  factory _FirestoreTextChatMessage({
    @required DocumentSnapshot document,
    @required String id,
    @required UserReference sender,
    @required DateTime sentAt,
    @required UsersReference readBy,
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
    @required UsersReference readBy,
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

class FirestoreChatMessageReference
    with IdentifiableBySubstanceId<ChatMessageReference, ChatMessage>
    implements ChatMessageReference {
  FirestoreChatMessageReference(DocumentReference documentReference)
      : assert(documentReference != null),
        _documentReference = documentReference;

  final DocumentReference _documentReference;

  @override
  String get substanceId => _documentReference.documentID;

  @override
  Future<ChatMessage> get resolve => _documentReference
      .get()
      .then((document) => FirestoreChatMessage(document))
        ..then((chatMessage) {
          _chatMessage = chatMessage;
        });

  ChatMessage _chatMessage;

  @override
  ChatMessage get value => _chatMessage;
}

class FirestoreChatMessagesObservable implements ChatMessagesObservable {
  FirestoreChatMessagesObservable.fromCollectionReferences(
      CollectionReference collectionReferences)
      : _stream = collectionReferences.snapshots().map((snapshot) => snapshot
            .documents
            .map((document) => FirestoreChatMessage(document)));

  final Stream<Iterable<FirestoreChatMessage>> _stream;

  @override
  Stream<Iterable<FirestoreChatMessage>> get onChanged => _stream
    ..listen((chatMessages) {
      _chatMessages = chatMessages;
    });

  Iterable<FirestoreChatMessage> _chatMessages;

  @override
  Iterable<FirestoreChatMessage> get latest => _chatMessages;
}
