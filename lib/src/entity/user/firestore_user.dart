import 'package:caramel/entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;
import 'package:meta/meta.dart';

class FirestoreUser implements User {
  FirestoreUser factory FirestoreUser.fromDocument(DocumentSnapshot documentSnapshot) {
    final uid = documentSnapshot.documentID;
    final maybeName = documentSnapshot.data['name'];
    final maybeImageUrlString = documentSnapshot.data['imageUrl'];

    assert(maybeName is String);
    assert(maybeName != null);
    assert(maybeImageUrlString is String);
    assert(maybeImageUrlString != null);

    final imageUrl = Uri.parse(maybeImageUrlString);

    return FirestoreUser._(uid: uid, name: maybeName, imageUrl: imageUrl);
  }

  FirestoreUser._({
    @required this.uid,
    @required this.name,
    @required this.imageUrl,
  })  : assert(uid != null),
        assert(name != null),
        assert(imageUrl != null);

  final String uid;
  final String name;
  final Uri imageUrl;
}
