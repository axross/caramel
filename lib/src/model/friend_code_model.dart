import 'package:caramel/entities.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

/// A model managing the available [FriendCode] of the [User].
abstract class FriendCodeModel {
  /// Creates a [FriendCodeModel].
  factory FriendCodeModel({
    @required User user,
    @required FriendCodeRepositoryService friendCodeRepositoryService,
  }) =>
      _FriendCodeModel(
        user: user,
        friendCodeRepositoryService: friendCodeRepositoryService,
      );

  /// Fires whenever the available [FriendCode] changes.
  Stream<FriendCode> get onChanged;

  /// The available [FriendCode].
  FriendCode get friendCode;
}

class _FriendCodeModel implements FriendCodeModel {
  _FriendCodeModel({
    @required User user,
    @required FriendCodeRepositoryService friendCodeRepositoryService,
  })  : assert(friendCodeRepositoryService != null),
        assert(user != null),
        _friendCodeRepositoryService = friendCodeRepositoryService,
        _user = user;

  final FriendCodeRepositoryService _friendCodeRepositoryService;
  final User _user;
  FriendCode _friendCode;

  @override
  Stream<FriendCode> get onChanged =>
      _friendCodeRepositoryService.subscribeNewestFriendCode(_user)
        ..listen((friendCode) {
          _friendCode = friendCode;
        });

  @override
  FriendCode get friendCode => _friendCode;
}
