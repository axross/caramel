import 'package:caramel/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

abstract class AuthenticationModel {
  factory AuthenticationModel({
    @required auth,
    @required firestore,
  }) =>
      _AuthenticationModelImpl(auth: auth, firestore: firestore);

  Stream<User> get onUserChanged;

  User get user;
}

class _AuthenticationModelImpl implements AuthenticationModel {
  _AuthenticationModelImpl({
    @required auth,
    @required firestore,
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
