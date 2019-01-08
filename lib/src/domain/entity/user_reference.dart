import 'package:caramel/domains.dart';

/// An entity of reference to [User].
abstract class UserReference
    with IdentifiableBySubstanceId<UserReference, User> {
  /// Resolves to obtain the [User].
  Future<User> get resolve;

  /// The resolved [User]. If this has never been resolved, its `null`.
  User get value;
}

abstract class SignedInUserReference extends UserReference {
  @override
  Future<SignedInUser> get resolve;

  @override
  SignedInUser get value;
}
