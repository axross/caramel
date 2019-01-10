import 'package:caramel/domains.dart';
import 'package:caramel/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:meta/meta.dart';

class FirebaseUserRepository implements UserRepository {
  FirebaseUserRepository({
    @required Firestore firestore,
    @required CloudFunctions functions,
  })  : assert(firestore != null),
        assert(functions != null),
        _firestore = firestore,
        _functions = functions;

  final Firestore _firestore;

  final CloudFunctions _functions;

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
  Stream<Iterable<Friendship>> subscribeFriendships({@required User hero}) =>
      _firestore
          .collection('users')
          .document(hero.id)
          .collection('friendships')
          .snapshots()
          .map((snapshot) => snapshot.documents
              .map((document) => FirestoreFriendship(document)));

  @override
  Future<void> createFriendshipByFriendCode({
    @required FriendCode friendCode,
  }) async {
    try {
      await _functions.call(
        functionName: 'makeFriendshipByFriendCode',
        parameters: {
          'friendCode': friendCode.data,
        },
      );
    } on CloudFunctionsException catch (err) {
      if (err.code == 'INVALID_ARGUMENT') {
        rethrow;
      }

      if (err.code == 'NOT_FOUND') {
        throw FriendCodeNotExisting(friendCode: friendCode);
      }

      if (err.code == 'ALREADY_EXISTS') {
        throw AlreadyFriend();
      }

      if (err.code == 'INTERNAL') {
        throw ServerInternalException(message: err.message);
      }
    }
  }

  @override
  Future<void> deleteFriendship({
    @required SignedInUser hero,
    @required Friendship friendship,
  }) =>
      _firestore
          .collection('users')
          .document(hero.id)
          .collection('friendships')
          .document(friendship.id)
          .delete();

  @override
  Future<void> createUser({@required String id}) =>
      _functions.call(functionName: 'registerUser');

  @override
  Future<void> setDevice({
    @required SignedInUser hero,
    @required DeviceInformation deviceInformation,
    @required String pushNotificationDestinationId,
  }) =>
      _firestore
          .collection('users')
          .document(hero.id)
          .collection('devices')
          .document(deviceInformation.id)
          .setData({
        'manufacturer': deviceInformation.manufacturer,
        'model': deviceInformation.model,
        'os': deviceInformation.os,
        'osVersion': deviceInformation.osVersion,
        'pushNotificationDestinationId': pushNotificationDestinationId,
      });
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
