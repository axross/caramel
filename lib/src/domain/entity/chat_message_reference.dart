import 'package:caramel/domains.dart';

/// An entity of reference to [ChatMessage].
abstract class ChatMessageReference
    with IdentifiableBySubstanceId<ChatMessageReference, ChatMessage>
    implements StatefulFuture<ChatMessage> {}
