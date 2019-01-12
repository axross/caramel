import 'package:caramel/domains.dart';

/// An entity expressing a chat room.
abstract class Chat with Entity {
  /// The users participating in the chat.
  StatefulFuture<List<User>> get participants;

  /// The last [ChatMessage] in the chat.
  ChatMessageReference get lastChatMessage;

  /// All the [ChatMessage] posted in the chat.
  StatefulStream<List<ChatMessage>> get chatMessages;
}
