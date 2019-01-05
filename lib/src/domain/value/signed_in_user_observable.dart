import 'package:caramel/domains.dart';

/// An observable reference to [SignedInUser]s.
abstract class SignedInUserObservable {
  /// The stream of [SignedInUser]. Provides the new values whenever they
  /// update.
  Stream<SignedInUser> get onChanged;

  /// The latest value of [onChanged()]. If this has never been listened, its
  /// `null`.
  SignedInUser get latest;
}
