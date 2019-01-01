import 'package:caramel/entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;
import 'package:meta/meta.dart';

class FirestoreUser implements User {
  factory FirestoreUser.fromDocument(DocumentSnapshot documentSnapshot) {
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

  @override
  final String uid;

  @override
  final String name;

  @override
  final Uri imageUrl;
}
