import 'dart:async';
import 'package:caramel/entities.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

abstract class FriendListModel {
  factory FriendListModel(
    User user, {
    @required FriendRepositoryService friendRepositoryService,
  }) =>
      _FriendListModelImpl(
        user: user,
        friendRepositoryService: friendRepositoryService,
      );

  Stream<Iterable<Friendship>> get onChanged;

  Sink<Friendship> get deletion;

  Iterable<Friendship> get friendships;

  void dispose();
}

class _FriendListModelImpl implements FriendListModel {
  _FriendListModelImpl({
    @required User user,
    @required FriendRepositoryService friendRepositoryService,
  })  : _friendRepositoryService = friendRepositoryService,
        _user = user {
    _deletion.stream.listen((friend) async {
      final friendUser = await friend.user.resolve();

      await _friendRepositoryService.delete(_user, friendUser);
    });
  }

  final FriendRepositoryService _friendRepositoryService;
  final User _user;
  Iterable<Friendship> _friendships = [];

  final StreamController<Friendship> _deletion = StreamController();

  @override
  Stream<Iterable<Friendship>> get onChanged =>
      _friendRepositoryService.subscribeFriendships(_user)
        ..listen((friendships) {
          _friendships = friendships;
        });

  @override
  Sink<Friendship> get deletion => _deletion.sink;

  @override
  Iterable<Friendship> get friendships => _friendships;

  @override
  void dispose() {
    _deletion.close();
  }
}
