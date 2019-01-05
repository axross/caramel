import 'package:caramel/domains.dart';

/// An entity expressing a chat room.
abstract class Chat with IdentifiableById<Chat> {
  /// The users participating in the chat.
  UsersReference get participants;

  /// The last [ChatMessage] in the chat.
  ChatMessageReference get lastChatMessage;

  /// All the [ChatMessage] posted in the chat.
  ChatMessagesObservable get chatMessages;
}
