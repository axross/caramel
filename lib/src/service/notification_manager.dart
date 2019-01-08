import 'package:caramel/domains.dart';
import 'package:meta/meta.dart';

abstract class NotificationManager {
  Stream<ChatMessageNotification> get onChatMessageNotificationOpened;

  Future<void> subscribeChat({
    @required ChatReference chat,
    @required SignedInUser hero,
  });

  Future<void> unsubscribeChat({
    @required ChatReference chat,
    @required SignedInUser hero,
  });
}

abstract class ChatMessageNotification {
  ChatReference get chat;

  ChatMessageReference get chatMessage;
}
