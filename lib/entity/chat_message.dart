import 'package:meta/meta.dart';
import './user_reference.dart';

enum ChatMessageType {
  Text,
}

abstract class ChatMessage {
  final UserReference from;
  final DateTime sentAt;
  final List<UserReference> readBy;

  ChatMessage({
    @required this.from,
    @required this.sentAt,
    @required this.readBy,
  })  : assert(from != null),
        assert(sentAt != null),
        assert(readBy != null);
}

abstract class TextChatMessage extends ChatMessage {
  final String text;

  TextChatMessage({
    @required UserReference from,
    @required DateTime sentAt,
    @required List<UserReference> readBy,
    @required this.text,
  }) : super(from: from, sentAt: sentAt, readBy: readBy);
}
