import 'package:caramel/domains.dart';

/// A reference to specific [User]s.
abstract class UsersReference {
  /// Resolves to obtain the [User]s.
  Future<Iterable<User>> get resolve;

  /// The resolved [User]s. If this has never been resolved, its `null`.
  Iterable<User> get value;
}
