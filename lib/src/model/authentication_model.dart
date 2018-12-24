import 'package:caramel/entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

class AuthenticationModel {
  AuthenticationModel({
    @required auth,
    @required firestore,
  })  : assert(auth != null),
        assert(firestore != null),
        _auth = auth,
        _firestore = firestore;

  final FirebaseAuth _auth;
  final Firestore _firestore;
  User _user;

  Stream<User> get onUserChanged =>
      _auth.onAuthStateChanged.asyncMap<User>((firebaseUser) async {
        if (firebaseUser == null) {
          _user = null;

          return null;
        }

        DocumentSnapshot userDocument = await _getSelfUser(firebaseUser);

        if (!userDocument.exists) {
          await _registerNewUser(firebaseUser);

          userDocument = await _getSelfUser(firebaseUser);
        }

        final user = User.fromFirestoreDocument(userDocument);

        _user = user;

        return user;
      });

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

final url = Uri.https(
  'firebasestorage.googleapis.com',
  '/v0/b/caramel-b3766.appspot.com/o/profile_images%2F0000000000000000000000000000000000000000000000000000000000000000.png',
  {
    'alt': 'media',
    'token': '96813a04-7edc-499d-b1cc-dcf2f3bbabc8',
  },
);
