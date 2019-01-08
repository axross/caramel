import 'dart:async';
import 'package:caramel/domains.dart';
import 'package:caramel/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:onesignal/onesignal.dart';

class OnesignalFirestoreNotificationManager implements NotificationManager {
  OnesignalFirestoreNotificationManager({
    @required OneSignal onesignal,
    @required String appId,
    @required Firestore firestore,
  })  : assert(onesignal != null),
        assert(appId != null),
        assert(firestore != null),
        _onesignal = onesignal,
        _onChatMessageNotificationOpened = StreamController(),
        _firestore = firestore {
    onesignal
      ..init(appId)
      ..setInFocusDisplayType(OSNotificationDisplayType.notification)
      ..setNotificationOpenedHandler((openedResult) {
        print(openedResult.notification.payload.additionalData);

        final type = openedResult.notification.payload.additionalData['type'];

        if (type == 'chatMessage') {
          _onChatMessageNotificationOpened
              .add(_OnesignalFirestoreChatMessageNotification(
            onesignalNotification: openedResult.notification,
            firestore: _firestore,
          ));

          return;
        }

        throw Exception();
      });
  }

  final OneSignal _onesignal;

  final Firestore _firestore;

  final StreamController<ChatMessageNotification>
      _onChatMessageNotificationOpened;

  @override
  Stream<ChatMessageNotification> get onChatMessageNotificationOpened =>
      _onChatMessageNotificationOpened.stream;

  @override
  Future<void> subscribeChat({
    @required ChatReference chat,
    @required SignedInUser hero,
  }) =>
      chat.resolve.then((chat) => chat.participants.resolve).then((users) {
        final membersWithoutHero = users.where((user) => hero != user);
        final tags = Map.fromIterable(
          membersWithoutHero,
          key: (user) => 'chats/${chat.substanceId}?without=${user.id}',
          value: (_) => true,
        );

        return _onesignal.sendTags(tags);
      });

  @override
  Future<void> unsubscribeChat({
    @required ChatReference chat,
    @required SignedInUser hero,
  }) =>
      chat.resolve.then((chat) => chat.participants.resolve).then((users) {
        final membersWithoutHero = users.where((user) => hero != user);
        final tags = membersWithoutHero
            .map((user) => 'chats/${chat.substanceId}?without=${user.id}');

        return _onesignal.deleteTags(tags.toList());
      });
}

class _OnesignalFirestoreChatMessageNotification
    implements ChatMessageNotification {
  factory _OnesignalFirestoreChatMessageNotification({
    @required OSNotification onesignalNotification,
    @required Firestore firestore,
  }) {
    final maybeChatId = onesignalNotification.payload.additionalData['chatId'];
    final maybeChatMessageId =
        onesignalNotification.payload.additionalData['chatMessageId'];

    assert(maybeChatId != null);
    assert(maybeChatId is String);
    assert(maybeChatMessageId != null);
    assert(maybeChatMessageId is String);

    return _OnesignalFirestoreChatMessageNotification._(
      chat: FirestoreChatReference(
        firestore.collection('chats').document(maybeChatId),
      ),
      chatMessage: FirestoreChatMessageReference(
        firestore
            .collection('chats')
            .document(maybeChatId)
            .collection('messages')
            .document(maybeChatMessageId),
      ),
    );
  }

  _OnesignalFirestoreChatMessageNotification._({
    @required this.chat,
    @required this.chatMessage,
  })  : assert(chat != null),
        assert(chatMessage != null);

  @override
  final ChatReference chat;

  @override
  final ChatMessageReference chatMessage;
}
