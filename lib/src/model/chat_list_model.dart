import 'dart:async';
import 'package:caramel/entities.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

abstract class ChatListModel {
  factory ChatListModel({
    @required ChatRepositoryService chatRepositoryService,
    @required User user,
  }) =>
      _ChatListModelImpl(
        chatRepositoryService: chatRepositoryService,
        user: user,
      );

  Iterable<Chat> get chats;

  Stream<Iterable<Chat>> get onChanged;

  Sink<User> get creation;

  void dispose();
}

class _ChatListModelImpl implements ChatListModel {
  _ChatListModelImpl({
    @required ChatRepositoryService chatRepositoryService,
    @required User user,
  })  : assert(chatRepositoryService != null),
        assert(user != null),
        _chatRepositoryService = chatRepositoryService,
        _user = user {
    _creation.stream.listen((friend) {
      _chatRepositoryService.createChat(user, friend);
    });
  }

  final ChatRepositoryService _chatRepositoryService;
  final User _user;
  final StreamController<User> _creation = StreamController();
  Iterable<Chat> _chats = [];

  @override
  Iterable<Chat> get chats => _chats;

  @override
  Stream<Iterable<Chat>> get onChanged =>
      _chatRepositoryService.subscribeChats(_user)
        ..listen((chats) {
          _chats = chats;
        });

  @override
  Sink<User> get creation => _creation.sink;

  @override
  void dispose() {
    _creation.close();
  }
}
