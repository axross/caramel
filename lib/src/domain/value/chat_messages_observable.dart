import 'package:caramel/domains.dart';

/// An observable reference to specific [ChatMessage]s.
abstract class ChatMessagesObservable {
  /// The stream of the [ChatMessage]s. Provides the new values whenever they
  /// update.
  Stream<Iterable<ChatMessage>> get onChanged;

  /// The latest value of [onChanged()]. If this has never been listened, its
  /// `null`.
  Iterable<ChatMessage> get latest;
}
