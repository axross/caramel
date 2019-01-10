import 'package:caramel/domains.dart';

abstract class NotificationManager {
  Future<String> get pushNotificationDestinationId;

  Stream<ChatMessageNotification> get onChatMessageNotificationOpened;
}

abstract class ChatMessageNotification {
  ChatReference get chat;

  ChatMessageReference get chatMessage;
}
