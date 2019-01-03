import 'package:caramel/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

/// A model managing authentication and the current signed-in [User].
abstract class AuthenticationModel {
  /// Creates an [AuthenticationModel].
  factory AuthenticationModel({
    @required FirebaseAuth auth,
    @required Firestore firestore,
  }) =>
      _AuthenticationModel(auth: auth, firestore: firestore);

  /// Fires whenever the signed-in [User] changes.
  Stream<User> get onUserChanged;

  /// The current signed-in user. If no user signed in, returns `null`.
  User get user;
}

class _AuthenticationModel implements AuthenticationModel {
  _AuthenticationModel({
    @required FirebaseAuth auth,
    @required Firestore firestore,
  })  : assert(auth != null),
        assert(firestore != null),
        _auth = auth,
        _firestore = firestore;

  final FirebaseAuth _auth;
  final Firestore _firestore;
  User _user;

  @override
  Stream<User> get onUserChanged =>
      _auth.onAuthStateChanged.asyncMap<User>((firebaseUser) async {
        if (firebaseUser == null) {
          _user = null;

          return null;
        }

        var userDocument = await _getSelfUser(firebaseUser);

        if (!userDocument.exists) {
          await _registerNewUser(firebaseUser);

          userDocument = await _getSelfUser(firebaseUser);
        }

        final user = User.fromFirestoreDocument(userDocument);

        _user = user;

        return user;
      });

  @override
  User get user => _user;

  Future<void> _registerNewUser(FirebaseUser firebaseUser) async {
    await _firestore
        .collection('users')
        .document('${firebaseUser.uid}')
        .setData({
      'name': firebaseUser.displayName.isNotEmpty
          ? firebaseUser.displayName
          : 'No Name',
      'imageUrl':
          'gs://caramel-b3766.appspot.com/profile_images/0000000000000000000000000000000000000000000000000000000000000000.png',
    });
  }

  Future<DocumentSnapshot> _getSelfUser(FirebaseUser firebaseUser) async =>
      await _firestore.document('users/${firebaseUser.uid}').get();
}
