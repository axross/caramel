abstract class Authenticator {
  Stream<String> observeSignedInUserId();

  void signIn();
}
