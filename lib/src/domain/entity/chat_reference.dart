import 'package:caramel/domains.dart';

/// An entity of reference to [Chat].
abstract class ChatReference
    with ReferenceEntity
    implements StatefulFuture<Chat> {}
