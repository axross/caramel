import 'package:caramel/domains.dart';
import 'package:meta/meta.dart';

abstract class Authenticator {
  Stream<SignedInUser> observeSignedInUser({
    @required Future<SignedInUser> Function(String id) registerUser,
  });

  void signIn();
}
