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
        _onChatMessageNotificationOpened = StreamController(),
        _firestore = firestore,
        _onesignal = onesignal {
    onesignal
      ..init(appId)
      ..setInFocusDisplayType(OSNotificationDisplayType.notification)
      ..setNotificationOpenedHandler((openedResult) {
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

  final Firestore _firestore;

  final OneSignal _onesignal;

  final StreamController<ChatMessageNotification>
      _onChatMessageNotificationOpened;

  @override
  Future<String> get pushNotificationDestinationId => _onesignal
      .getPermissionSubscriptionState()
      .then((state) => state.subscriptionStatus.userId);

  @override
  Stream<ChatMessageNotification> get onChatMessageNotificationOpened =>
      _onChatMessageNotificationOpened.stream;
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
