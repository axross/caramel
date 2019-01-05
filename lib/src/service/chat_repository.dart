import 'package:caramel/domains.dart';
import 'package:meta/meta.dart';

/// A repository handling [Chat]s.
abstract class ChatRepository {
  /// Returns a stream of the user's list of [Chat]s.
  Stream<Iterable<Chat>> subscribeChats({
    @required SignedInUser hero,
  });

  Future<Chat> getChatById({
    @required String chatId,
  });

  /// Find the one-on-one chat. Returns `Future<Null>` if it doesn't exist.
  Future<Chat> findOneOnOneChat({
    @required SignedInUser hero,
    @required User opponent,
  });

  /// Creates an one-on-one chat.
  Future<void> createOneOnOneChat({
    @required SignedInUser hero,
    @required User opponent,
  });

  /// Posts a [TextChatMessage] in a chat.
  Future<void> postTextToChat({
    @required SignedInUser hero,
    @required Chat chat,
    @required String text,
  });
}
