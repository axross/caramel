import 'dart:async';
import 'package:caramel/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show Firestore;
import 'package:meta/meta.dart';

/// A repository service of lists of chats.
abstract class ChatRepositoryService {
  /// Creates [ChatRepositoryService] with a [Firestore].
  factory ChatRepositoryService.withFirestore({
    @required Firestore firestore,
  }) =>
      _FirestoreChatRepositoryService(firestore: firestore);

  /// Subscribes the changes of the list of [Chat]s the [user] participates in.
  Stream<Iterable<Chat>> subscribeChats(User user);

  ///
  @deprecated
  Stream<Chat> subscribeChatByFriendship(User user, Friendship friendship);

  /// Creates an one-on-one chat with the [user] and [friend].
  Future<void> createChat(User user, User friend);
}

class _FirestoreChatRepositoryService implements ChatRepositoryService {
  _FirestoreChatRepositoryService({
    @required Firestore firestore,
  })  : assert(firestore != null),
        _firestore = firestore;

  final Firestore _firestore;

  @override
  Stream<Iterable<Chat>> subscribeChats(User user) => _firestore
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
  Future<void> createChat(User user, User friend) async =>
      await _firestore.collection('chats').document().setData({
        'members': [
          _firestore.document('users/${user.uid}'),
          _firestore.document('users/${friend.uid}'),
        ],
      });
}
