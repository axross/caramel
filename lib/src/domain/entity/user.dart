import 'package:caramel/domains.dart';

/// An entity expressing an user of the application.
abstract class User with Entity {
  /// The name.
  String get name;

  /// The URL to the image file.
  Uri get imageUrl;
}

abstract class OtherUser extends User {}

/// Another version of [User] which is signed-in user (the hero) of the
/// application.
abstract class SignedInUser extends User {}
