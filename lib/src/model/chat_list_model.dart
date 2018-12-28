import 'dart:async';
import 'package:caramel/entities.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

class ChatListModel {
  ChatListModel({
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

  Iterable<Chat> get chats => _chats;

  Stream<Iterable<Chat>> get onChanged =>
      _chatRepositoryService.subscribeChats(_user)
        ..listen((chats) {
          _chats = chats;
        });

  Sink<User> get creation => _creation.sink;

  void dispose() {
    _creation.close();
  }
}
