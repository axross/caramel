import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;
import 'package:meta/meta.dart';

/// An user.
@immutable
abstract class User {
  /// Creates an [User] from Firebase [DocumentSnapshot].
  factory User.fromFirestoreDocument(DocumentSnapshot document) =>
      _FirestoreUser.fromDocument(document);

  /// 消すかも
  @deprecated
  String get uid;

  /// The name of the user.
  String get name;

  /// The URL to the image file.
  Uri get imageUrl;
}

@immutable
class _FirestoreUser implements User {
  factory _FirestoreUser.fromDocument(DocumentSnapshot documentSnapshot) {
    final uid = documentSnapshot.documentID;
    final maybeName = documentSnapshot.data['name'];
    final maybeImageUrlString = documentSnapshot.data['imageUrl'];

    assert(maybeName is String);
    assert(maybeName != null);
    assert(maybeImageUrlString is String);
    assert(maybeImageUrlString != null);

    final imageUrl = Uri.parse(maybeImageUrlString);

    return _FirestoreUser._(uid: uid, name: maybeName, imageUrl: imageUrl);
  }

  const _FirestoreUser._({
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
