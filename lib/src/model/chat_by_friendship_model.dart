import 'dart:async';
import 'package:caramel/entities.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

abstract class ChatByFriendshipModel {
  factory ChatByFriendshipModel({
    @required User user,
    @required Friendship friendship,
    @required ChatRepositoryService chatRepositoryService,
  }) =>
      _ChatByFriendshipModelImpl(
        user: user,
        friendship: friendship,
        chatRepositoryService: chatRepositoryService,
      );

  Stream<Chat> get onChanged;

  Sink<void> get creation;

  Chat get chat;

  void dispose();
}

class _ChatByFriendshipModelImpl implements ChatByFriendshipModel {
  _ChatByFriendshipModelImpl({
    @required User user,
    @required Friendship friendship,
    @required ChatRepositoryService chatRepositoryService,
  })  : assert(user != null),
        assert(friendship != null),
        assert(chatRepositoryService != null),
        _user = user,
        _friendship = friendship,
        _chatRepositoryService = chatRepositoryService {
    _creation.stream.listen((_) async {
      final friend = await friendship.user.resolve();

      await _chatRepositoryService.createChat(user, friend);
    });
  }

  final User _user;
  final Friendship _friendship;
  final ChatRepositoryService _chatRepositoryService;
  final StreamController<Friendship> _creation = StreamController();
  Chat _chat;

  @override
  Stream<Chat> get onChanged =>
      _chatRepositoryService.subscribeChatByFriendship(_user, _friendship)
        ..listen((chat) {
          _chat = chat;
        });

  @override
  Sink<void> get creation => _creation.sink;

  @override
  Chat get chat => _chat;

  @override
  void dispose() {
    _creation.close();
  }
}
