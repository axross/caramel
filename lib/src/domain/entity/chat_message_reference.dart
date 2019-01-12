import 'package:caramel/domains.dart';

/// An entity of reference to [ChatMessage].
abstract class ChatMessageReference
    with ReferenceEntity
    implements StatefulFuture<ChatMessage> {}
