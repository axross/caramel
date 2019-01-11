import 'package:caramel/domains.dart';

/// An entity of reference to [Chat].
abstract class ChatReference
    with IdentifiableBySubstanceId<ChatReference, Chat>
    implements StatefulFuture<Chat> {}
