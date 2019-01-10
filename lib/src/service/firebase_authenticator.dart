import 'package:caramel/domains.dart';
import 'package:caramel/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:meta/meta.dart';

class FirebaseAuthenticator implements Authenticator {
  FirebaseAuthenticator({
    @required FirebaseAuth auth,
    @required Firestore firestore,
    @required CloudFunctions functions,
  })  : assert(auth != null),
        assert(firestore != null),
        assert(functions != null),
        _auth = auth,
        _firestore = firestore,
        _functions = functions;

  final FirebaseAuth _auth;

  final Firestore _firestore;

  final CloudFunctions _functions;

  @override
  Stream<SignedInUser> observeSignedInUser({
    @required Future<SignedInUser> Function(String id) registerUser,
  }) =>
      _auth.onAuthStateChanged.asyncMap((firebaseUser) async {
        if (firebaseUser == null) {
          return null;
        }

        final userDoc = await _firestore
            .collection('users')
            .document(firebaseUser.uid)
            .get();

        if (userDoc.exists) {
          return FirestoreSignedInUser(userDoc);
        }

        return await registerUser(firebaseUser.uid);
      });

  @override
  void signIn() => _auth.signInAnonymously();
}
