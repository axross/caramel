import 'package:caramel/domains.dart';
import 'package:caramel/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class FirestoreUserRepository implements UserRepository {
  FirestoreUserRepository(Firestore firestore) : _firestore = firestore;

  final Firestore _firestore;

  @override
  Future<SignedInUser> getUserById(String id) =>
      _firestore.document('users/$id').get().then((document) {
        if (!document.exists) {
          throw UserNotExisting(id: id);
        }

        return FirestoreSignedInUser(document);
      });

  @override
  Future<void> registerAsNewUser(String id) =>
      _firestore.collection('users').document(id).setData({
        'name': 'No Name',
        'imageUrl':
            'gs://caramel-b3766.appspot.com/profile_images/0000000000000000000000000000000000000000000000000000000000000000.png',
      });

  @override
  Stream<Iterable<Friendship>> subscribeFriendships({@required User hero}) =>
      _firestore.collection('users/${hero.id}/friendships').snapshots().map(
          (snapshot) => snapshot.documents
              .map((document) => FirestoreFriendship(document)));

  @override
  Future<void> addFriendByFriendCode({
    @required User hero,
    @required FriendCode friendCode,
  }) async {
    /**
     * TODO(axross): the operations in the below are supposed to do with
     * transaction. but it doesn't work more than one write operations in a
     * transaction. I need to wait for this bug to be fixed in cloud_firestore
     * package.
     * see also: https://github.com/flutter/flutter/issues/17663
     */

    final friendCodeDoc =
        await _firestore.document('friendCodes/${friendCode.data}').get();

    if (!friendCodeDoc.exists) {
      throw FriendCodeNotExisting(friendCode: friendCode);
    }

    if (friendCodeDoc.data['user'] is! DocumentReference) {
      throw DatabaseBadState(
        detail: 'a document ${friendCodeDoc.reference.path} doesn\'t have a '
            'member `user` as a reference.',
      );
    }

    final heroRef = _firestore.document('users/${hero.id}');
    final DocumentReference opponentRef = friendCodeDoc.data['user'];
    final friendshipDoc = await opponentRef
        .collection('friendships')
        .document('${hero.id}')
        .get();

    DocumentReference chat;
    var isOpponentAlreadyAddedMe = false;

    if (friendshipDoc.exists) {
      // hero has already been opponent's friend

      if (friendshipDoc.data['chat'] is! DocumentReference) {
        throw DatabaseBadState(
          detail: 'a document `${friendshipDoc.reference.path}` doesn\'t '
              'have a member `chat` as a reference.',
        );
      }

      chat = friendshipDoc.data['chat'];
      isOpponentAlreadyAddedMe = true;
    } else {
      // this is the first time to know each other

      chat = _firestore.collection('chats').document();
    }

    final opponentId = opponentRef.documentID;

    final batch = _firestore.batch()
      ..setData(
        heroRef.collection('friendships').document(opponentId),
        {
          'user': opponentRef,
          'chat': chat,
        },
      );

    if (!isOpponentAlreadyAddedMe) {
      batch
        ..setData(
          opponentRef.collection('friendships').document(hero.id),
          {
            'user': heroRef,
            'chat': chat,
          },
        )
        ..setData(
          chat,
          {
            'members': [
              _firestore.document('users/${hero.id}'),
              _firestore.document('users/$opponentId'),
            ],
          },
        );
    }

    await batch.commit();
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
  Future<User> get resolve =>
      _documentReference.get().then((document) => FirestoreUser(document))
        ..then((user) {
          _user = user;
        });

  User _user;

  @override
  User get value => _user;
}

class FirestoreUsersReference implements UsersReference {
  FirestoreUsersReference.fromDocumentReferences(
    Iterable<DocumentReference> documentReferences,
  ) : _resolve = Future.wait(documentReferences.map((documentReference) =>
            documentReference
                .get()
                .then((document) => FirestoreUser(document))));

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
