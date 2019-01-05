import 'package:caramel/domains.dart';

/// An observable reference to a [FriendCode].
abstract class FriendCodeObservable {
  /// The stream of [FriendCode]. Provides the new values whenever they
  /// update.
  Stream<FriendCode> get onChanged;

  /// The latest value of [onChanged()]. If this has never been listened, its
  /// `null`.
  FriendCode get latest;
}
