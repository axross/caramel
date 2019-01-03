import 'dart:async';
import 'package:caramel/entities.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

/// A model managing the list of [Friendship]s the user participated in.
///
/// When the instance doesn't need anymore, [dispose()] should be called.
abstract class FriendListModel {
  /// Creates a [FriendListModel].
  factory FriendListModel({
    @required User user,
    @required FriendRepositoryService friendRepositoryService,
  }) =>
      _FriendListModel(
        user: user,
        friendRepositoryService: friendRepositoryService,
      );

  /// Fires whenever the list of [Friendship]s changes.
  Stream<Iterable<Friendship>> get onChanged;

  /// The [Sink] to request deleting a [Friendship].
  Sink<Friendship> get deletion;

  /// The current list of [Friendship]s.
  Iterable<Friendship> get friendships;

  /// Closes all [Sink]s used in the instance. This method should be called
  /// when the instance doesn't need anymore.
  void dispose();
}

class _FriendListModel implements FriendListModel {
  _FriendListModel({
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
