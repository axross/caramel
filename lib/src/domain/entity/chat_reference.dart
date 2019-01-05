import 'package:caramel/domains.dart';

/// An entity of reference to [Chat].
abstract class ChatReference
    with IdentifiableBySubstanceId<ChatReference, Chat> {
  /// Resolves to obtain the [Chat].
  Future<Chat> get resolve;

  /// The resolved [Chat]. If this has never been resolved, its `null`.
  Chat get value;
}
