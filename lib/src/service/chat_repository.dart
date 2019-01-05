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

  /// Posts a [TextChatMessage] in a chat.
  Future<void> postTextToChat({
    @required SignedInUser hero,
    @required Chat chat,
    @required String text,
  });
}
