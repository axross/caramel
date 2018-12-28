import 'dart:async';
import 'package:caramel/entities.dart';
import 'package:caramel/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class FirestoreChatRepositoryService implements ChatRepositoryService {
  FirestoreChatRepositoryService({
    @required Firestore firestore,
  })  : assert(firestore != null),
        _firestore = firestore;

  final Firestore _firestore;

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
            if (snapshot.documents.isEmpty) return;

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
            if (snapshot.documents.isEmpty) return;

            final chat = Chat.fromFirestoreDocument(snapshot.documents.first);

            streamController.sink.add(chat);
          });
    });

    streamController.onCancel = () {
      if (streamController.hasListener) return;

      streamController.close();
    };

    return streamController.stream;
  }

  Future<void> createChat(User user, User friend) async =>
      await _firestore.collection('chats').document().setData({
        'members': [
          _firestore.document('users/${user.uid}'),
          _firestore.document('users/${friend.uid}'),
        ],
      });
}
