import 'dart:async';
import 'package:caramel/entities.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

class ChatByFriendshipModel {
  ChatByFriendshipModel({
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

  Stream<Chat> get onChanged =>
      _chatRepositoryService.subscribeChatByFriendship(_user, _friendship)
        ..listen((chat) {
          _chat = chat;
        });

  Sink<void> get creation => _creation.sink;

  Chat get chat => _chat;

  void dispose() {
    _creation.close();
  }
}
