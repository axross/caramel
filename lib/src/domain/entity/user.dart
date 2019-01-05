import 'package:caramel/domains.dart';

/// An entity expressing an user of the application.
abstract class User
    with IdentifiableById<User>, ComparableWithReference<User, UserReference> {
  /// The name.
  String get name;

  /// The URL to the image file.
  Uri get imageUrl;
}

/// Another version of [User] which is signed-in user (the hero) of the
/// application.
abstract class SignedInUser extends User {}
