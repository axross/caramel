import 'package:caramel/domains.dart';

/// An entity of reference to [ChatMessage].
abstract class ChatMessageReference
    with IdentifiableBySubstanceId<ChatMessageReference, ChatMessage> {
  /// Resolves to obtain the [ChatMessage].
  Future<ChatMessage> get resolve;

  /// The resolved [ChatMessage]. If this has never been resolved, its `null`.
  ChatMessage get value;
}
