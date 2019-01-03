import 'dart:async';
import 'package:caramel/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart'
    show FieldValue, Firestore;
import 'package:meta/meta.dart';

/// A repository service of chat.
abstract class ChatRepositoryService {
  /// Creates [ChatRepositoryService] with a [Firestore].
  factory ChatRepositoryService.withFirestore({
    @required Firestore firestore,
  }) =>
      _FirestoreChatRepositoryService(firestore: firestore);

  /// Subscribes the changes of the list of [Chat]s the [user] participates in.
  Stream<Iterable<Chat>> subscribeChatsByUser(User user);

  ///
  @deprecated
  Stream<Chat> subscribeChatByFriendship(User user, Friendship friendship);

  /// Subscribes the changes of the list of [ChatMessage]s in the [chat].
  Stream<Iterable<ChatMessage>> subscribeChatMessagesinChat(Chat chat);

  /// Creates an one-on-one chat with the [user] and [friend].
  Future<void> createChat(User user, User friend);

  /// Posts a [TextChatMessage].
  Future<void> postText({
    @required String text,
    @required Chat chat,
    @required User user,
  });
}

class _FirestoreChatRepositoryService implements ChatRepositoryService {
  _FirestoreChatRepositoryService({
    @required Firestore firestore,
  })  : assert(firestore != null),
        _firestore = firestore;

  final Firestore _firestore;

  @override
  Stream<Iterable<Chat>> subscribeChatsByUser(User user) => _firestore
      .collection('chats')
      .where(
        'members',
        arrayContains: _firestore.document('users/${user.uid}'),
      )
      .orderBy('lastMessageCreatedAt', descending: true)
      .snapshots()
      .map(
        (query) => query.documents
            .map((document) => Chat.fromFirestoreDocument(document)),
      );

  @override
  Stream<Chat> subscribeChatByFriendship(User user, Friendship friendship) {
    final streamController = StreamController<Chat>.broadcast();

    friendship.user.resolve().then((friend) {
      _firestore
          .collection('chats')
          .where('members', isEqualTo: [
            _firestore.document('users/${user.uid}'),
            _firestore.document('users/${friend.uid}'),
          ])
          .snapshots()
          .listen((snapshot) {
            if (snapshot.documents.isEmpty) {
              return;
            }

            final chat = Chat.fromFirestoreDocument(snapshot.documents.first);

            streamController.sink.add(chat);
          });

      _firestore
          .collection('chats')
          .where('members', isEqualTo: [
            _firestore.document('users/${friend.uid}'),
            _firestore.document('users/${user.uid}'),
          ])
          .snapshots()
          .listen((snapshot) {
            if (snapshot.documents.isEmpty) {
              return;
            }

            final chat = Chat.fromFirestoreDocument(snapshot.documents.first);

            streamController.sink.add(chat);
          });
    });

    streamController.onCancel = () {
      if (streamController.hasListener) {
        return;
      }

      streamController.close();
    };

    return streamController.stream;
  }

  @override
  Stream<Iterable<ChatMessage>> subscribeChatMessagesinChat(Chat chat) =>
      _firestore
          .collection('chats/${chat.id}/messages')
          .orderBy('sentAt', descending: true)
          .limit(100)
          .snapshots()
          .map(
            (query) => query.documents.map(
                  (document) => ChatMessage.fromFirestoreDocument(document),
                ),
          );

  @override
  Future<void> createChat(User user, User friend) async =>
      await _firestore.collection('chats').document().setData({
        'members': [
          _firestore.document('users/${user.uid}'),
          _firestore.document('users/${friend.uid}'),
        ],
      });

  @override
  Future<void> postText({
    @required String text,
    @required Chat chat,
    @required User user,
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
        'from': _firestore.document('users/${user.uid}'),
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
