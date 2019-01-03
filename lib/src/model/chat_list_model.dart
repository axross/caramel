import 'dart:async';
import 'package:caramel/entities.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

/// A model managing the list of [Chat]s the user participated in.
///
/// When the instance doesn't need anymore, [dispose()] should be called.
abstract class ChatListModel {
  /// Creates a [ChatListModel].
  factory ChatListModel({
    @required ChatRepositoryService chatRepositoryService,
    @required User user,
  }) =>
      _ChatListModel(
        chatRepositoryService: chatRepositoryService,
        user: user,
      );

  /// Fires whenever the list of [Chat]s changes.
  Stream<Iterable<Chat>> get onChanged;

  /// The [Sink] to request creating a new [Chat] with the given [User].
  Sink<User> get creation;

  /// The current list of [Chat]s.
  Iterable<Chat> get chats;

  /// Closes all [Sink]s used in the instance. This method should be called
  /// when the instance doesn't need anymore.
  void dispose();
}

class _ChatListModel implements ChatListModel {
  _ChatListModel({
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
      _chatRepositoryService.subscribeChatsByUser(_user)
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
