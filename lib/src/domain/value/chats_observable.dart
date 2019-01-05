import 'package:caramel/domains.dart';

/// An observable reference to specific [Chat]s.
abstract class ChatsObservable {
  /// The stream of the [Chat]s. Provides the new values whenever they update.
  Stream<Iterable<Chat>> get onChanged;

  /// The latest value of [onChanged()]. If this has never been listened, its
  /// `null`.
  Iterable<Chat> get latest;
}
