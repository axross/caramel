import 'package:caramel/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

class FirebaseAuthenticator implements Authenticator {
  FirebaseAuthenticator({@required FirebaseAuth auth})
      : assert(auth != null),
        _auth = auth;

  final FirebaseAuth _auth;

  @override
  Stream<String> observeSignedInUserId() =>
      _auth.onAuthStateChanged.map((firebaseUser) => firebaseUser.uid);

  @override
  void signIn() => _auth.signInAnonymously();
}
