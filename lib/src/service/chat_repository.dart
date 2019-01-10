import 'package:caramel/domains.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

/// A repository handling [Chat]s.
abstract class ChatRepository {
  /// Returns a stream of the user's list of [Chat]s.
  Stream<Iterable<Chat>> subscribeChats({
    @required SignedInUser hero,
  });

  ChatReference referChatById({@required String id});

  /// Posts a [TextChatMessage] in a chat.
  Future<void> postTextToChat({
    @required SignedInUser hero,
    @required ChatReference chat,
    @required String text,
  });
}
