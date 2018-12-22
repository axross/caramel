import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;
import 'package:meta/meta.dart';
import './user.dart';

export './user.dart';

class DatabaseUser implements User {
  final String uid;
  final String name;
  final Uri imageUrl;

  DatabaseUser factory DatabaseUser.fromDocument(DocumentSnapshot documentSnapshot) {
    final uid = documentSnapshot.documentID;
    final maybeName = documentSnapshot.data['name'];
    final maybeImageUrlString = documentSnapshot.data['imageUrl'];

    assert(maybeName is String);
    assert(maybeName != null);
    assert(maybeImageUrlString is String);
    assert(maybeImageUrlString != null);

    final imageUrl = Uri.parse(maybeImageUrlString);

    return DatabaseUser._(uid: uid, name: maybeName, imageUrl: imageUrl);
  }

  DatabaseUser._({@required this.uid, @required this.name, @required this.imageUrl,}):
    assert(uid != null),
        assert(name != null),
        assert(imageUrl != null);
}
