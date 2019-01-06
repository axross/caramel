import 'package:caramel/domains.dart';
import 'package:caramel/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class FirestoreUserRepository implements UserRepository {
  FirestoreUserRepository(Firestore firestore) : _firestore = firestore;

  final Firestore _firestore;

  @override
  SignedInUserReference referByFirebaseAuthId({@required String id}) =>
      FirestoreSignedInUserReference(
          _firestore.collection('users').document(id));

  @override
  Future<UserReference> referUserByFriendCode({
    @required FriendCode friendCode,
  }) async {
    final friendCodeDoc = await _firestore
        .collection('friendCodes')
        .document(friendCode.data)
        .get();

    if (!friendCodeDoc.exists) {
      throw FriendCodeNotExisting(friendCode: friendCode);
    }

    if (friendCodeDoc.data['user'] is! DocumentReference) {
      throw DatabaseBadState(
        detail: 'a document ${friendCodeDoc.reference.path} doesn\'t have a '
            'member `user` as a reference.',
      );
    }

    final DocumentReference userRef = friendCodeDoc.data['user'];

    return FirestoreUserReference(userRef);
  }

  @override
  Future<void> registerUser({
    @required UserReference user,
    AtomicWrite atomicWrite,
  }) async {
    final userRef = _firestore.collection('users').document(user.substanceId);
    final data = {
      'name': 'No Name',
      'imageUrl': 'gs://caramel-b3766.appspot.com/profile_images/00000000000'
          '00000000000000000000000000000000000000000000000000000.png',
    };

    if (atomicWrite == null) {
      await userRef.setData(data);
    } else {
      atomicWrite.forFirestore.setData(userRef, data);
    }
  }

  @override
  Stream<Iterable<Friendship>> subscribeFriendships({@required User hero}) =>
      _firestore
          .collection('users')
          .document('hero.id')
          .collection('friendships')
          .snapshots()
          .map((snapshot) => snapshot.documents
              .map((document) => FirestoreFriendship(document)));

  @override
  Future<void> relateByFriendship({
    @required SignedInUser hero,
    @required UserReference opponent,
    @required ChatReference oneOnOneChat,
    AtomicWrite atomicWrite,
  }) async {
    final opponentRef =
        _firestore.collection('users').document(opponent.substanceId);
    final chatRef =
        _firestore.collection('chats').document(oneOnOneChat.substanceId);
    final myFriendshipRef = _firestore
        .collection('users')
        .document(hero.id)
        .collection('friendships')
        .document(opponent.substanceId);
    final opponentFriendshipRef = _firestore
        .collection('users')
        .document(opponent.substanceId)
        .collection('friendships')
        .document(hero.id);
    final data = {
      'user': opponentRef,
      'chat': chatRef,
    };

    if (atomicWrite == null) {
      final batch = _firestore.batch()
        ..setData(myFriendshipRef, data)
        ..setData(opponentFriendshipRef, data);

      await batch.commit();
    } else {
      atomicWrite.forFirestore.setData(myFriendshipRef, data);
      atomicWrite.forFirestore.setData(opponentFriendshipRef, data);
    }
  }

  @override
  Future<void> disrelateByFriendship({
    @required SignedInUser hero,
    @required Friendship friendship,
    AtomicWrite atomicWrite,
  }) async {
    final myFriendshipRef = _firestore
        .collection('users')
        .document(hero.id)
        .collection('friendships')
        .document(friendship.id);
    final myFriendshipDoc = await myFriendshipRef.get();
    final DocumentReference oppoenentRef = myFriendshipDoc.data['user'];
    final opponentFriendshipRef =
        oppoenentRef.collection('friendships').document(hero.id);

    if (atomicWrite == null) {
      final batch = _firestore.batch()
        ..delete(myFriendshipRef)
        ..delete(opponentFriendshipRef);

      await batch.commit();
    } else {
      atomicWrite.forFirestore
        ..delete(myFriendshipRef)
        ..delete(opponentFriendshipRef);
    }
  }
}

class FirestoreUser
    with IdentifiableById<User>, ComparableWithReference<User, UserReference>
    implements User {
  factory FirestoreUser(DocumentSnapshot document) {
    final maybeName = document.data['name'];
    final maybeImageUrlString = document.data['imageUrl'];

    assert(maybeName is String);
    assert(maybeName != null);
    assert(maybeImageUrlString is String);
    assert(maybeImageUrlString != null);

    final imageUrl = Uri.parse(maybeImageUrlString);

    return FirestoreUser._(
      id: document.documentID,
      name: maybeName,
      imageUrl: imageUrl,
    );
  }

  FirestoreUser._({
    @required this.id,
    @required this.name,
    @required this.imageUrl,
  })  : assert(id != null),
        assert(name != null),
        assert(imageUrl != null);

  @override
  final String id;

  @override
  final String name;

  @override
  final Uri imageUrl;
}

class FirestoreSignedInUser
    with IdentifiableById<User>, ComparableWithReference<User, UserReference>
    implements SignedInUser {
  factory FirestoreSignedInUser(DocumentSnapshot document) {
    final maybeName = document.data['name'];
    final maybeImageUrlString = document.data['imageUrl'];

    assert(maybeName is String);
    assert(maybeName != null);
    assert(maybeImageUrlString is String);
    assert(maybeImageUrlString != null);

    final imageUrl = Uri.parse(maybeImageUrlString);

    return FirestoreSignedInUser._(
      id: document.documentID,
      name: maybeName,
      imageUrl: imageUrl,
    );
  }

  FirestoreSignedInUser._({
    @required this.id,
    @required this.name,
    @required this.imageUrl,
  })  : assert(id != null),
        assert(name != null),
        assert(imageUrl != null);

  @override
  final String id;

  @override
  final String name;

  @override
  final Uri imageUrl;
}

class FirestoreUserReference
    with IdentifiableBySubstanceId<UserReference, User>
    implements UserReference {
  FirestoreUserReference(DocumentReference documentReference)
      : assert(documentReference != null),
        _documentReference = documentReference;

  final DocumentReference _documentReference;

  @override
  String get substanceId => _documentReference.documentID;

  @override
  Future<User> get resolve => _documentReference.get().then((document) {
        if (!document.exists) {
          throw UserNotExisting(id: document.documentID);
        }

        return FirestoreUser(document);
      })
        ..then((user) {
          _user = user;
        });

  User _user;

  @override
  User get value => _user;
}

class FirestoreSignedInUserReference implements SignedInUserReference {
  FirestoreSignedInUserReference(DocumentReference documentReference)
      : assert(documentReference != null),
        _documentReference = documentReference;

  final DocumentReference _documentReference;

  @override
  String get substanceId => _documentReference.documentID;

  @override
  Future<FirestoreSignedInUser> get resolve =>
      _documentReference.get().then((document) {
        if (!document.exists) {
          throw UserNotExisting(id: document.documentID);
        }

        return FirestoreSignedInUser(document);
      })
        ..then((user) {
          _user = user;
        });

  FirestoreSignedInUser _user;

  @override
  FirestoreSignedInUser get value => _user;
}

class FirestoreUsersReference implements UsersReference {
  FirestoreUsersReference.fromDocumentReferences(
    Iterable<DocumentReference> documentReferences,
  ) : _resolve = Future.wait(documentReferences.map(
            (documentReference) => documentReference.get().then((document) {
                  if (!document.exists) {
                    throw UserNotExisting(id: document.documentID);
                  }

                  return FirestoreUser(document);
                })));

  final Future<Iterable<User>> _resolve;

  @override
  Future<Iterable<User>> get resolve => _resolve
    ..then((users) {
      _users = users;
    });

  Iterable<User> _users;

  @override
  Iterable<User> get value => _users;
}

class FirestoreFriendship
    with IdentifiableById<Friendship>
    implements Friendship {
  factory FirestoreFriendship(DocumentSnapshot document) {
    final maybeFriend = document.data['user'];
    final maybeChat = document.data['chat'];

    assert(maybeFriend is DocumentReference);
    assert(maybeChat is DocumentReference);

    final user = FirestoreUserReference(maybeFriend);
    final oneOnOneChat = FirestoreChatReference(maybeChat);

    return FirestoreFriendship._(
      document: document,
      user: user,
      oneOnOneChat: oneOnOneChat,
    );
  }

  FirestoreFriendship._({
    @required DocumentSnapshot document,
    @required this.user,
    @required this.oneOnOneChat,
  })  : assert(document != null),
        assert(user != null),
        assert(oneOnOneChat != null),
        _document = document;

  final DocumentSnapshot _document;

  @override
  String get id => _document.documentID;

  @override
  final UserReference user;

  @override
  final ChatReference oneOnOneChat;
}
