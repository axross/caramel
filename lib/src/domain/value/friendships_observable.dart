import 'package:caramel/domains.dart';

/// An observable reference to [Friendship]s.
abstract class FriendshipsObservable {
  /// The stream of [Friendship]s. Provides the new values whenever they
  /// update.
  Stream<Iterable<Friendship>> get onChanged;

  /// The latest value of [onChanged()]. If this has never been listened, its
  /// `null`.
  Iterable<Friendship> get latest;
}
