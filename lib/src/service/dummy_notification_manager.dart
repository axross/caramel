import 'dart:async';
import 'package:caramel/services.dart';

class DummyNotificationManager implements NotificationManager {
  DummyNotificationManager()
      : _onChatMessageNotificationOpened = StreamController();

  final StreamController<ChatMessageNotification>
      _onChatMessageNotificationOpened;

  @override
  Future<String> get pushNotificationDestinationId => Future.value('');

  @override
  Stream<ChatMessageNotification> get onChatMessageNotificationOpened =>
      _onChatMessageNotificationOpened.stream;
}
