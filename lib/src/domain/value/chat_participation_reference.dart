import 'package:caramel/domains.dart';

/// A reference to a [ChatParticipation].
abstract class ChatParticipationReference {
  /// Resolves to obtain the [ChatParticipation].
  Future<ChatParticipation> get resolve;

  /// The resolved [ChatParticipation]. If this has never been resolved, its
  /// `null`.
  ChatParticipation get value;
}
