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

  ChatReference referNewChat();

  Future<void> createOneOnOneChat({
    @required ChatReference chatReference,
    @required SignedInUser hero,
    @required UserReference opponent,
    AtomicWrite atomicWrite,
  });

  Future<void> deleteChat({
    @required ChatReference chat,
    AtomicWrite atomicWrite,
  });

  /// Posts a [TextChatMessage] in a chat.
  Future<void> postTextToChat({
    @required SignedInUser hero,
    @required ChatReference chat,
    @required String text,
  });
}
