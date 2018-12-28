import 'dart:async';
import 'package:caramel/entities.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

class FriendListModel {
  FriendListModel(
    User user, {
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

  Stream<Iterable<Friendship>> get onChanged =>
      _friendRepositoryService.subscribeFriendships(_user)
        ..listen((friendships) {
          _friendships = friendships;
        });

  Sink<Friendship> get deletion => _deletion.sink;

  Iterable<Friendship> get friendships => _friendships;

  void dispose() {
    _deletion.close();
  }
}
