import 'package:caramel/entities.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

abstract class FriendCodeModel {
  factory FriendCodeModel(
    User user, {
    @required FriendCodeRepositoryService friendCodeRepositoryService,
  }) =>
      _FriendCodeModelImpl(
        user: user,
        friendCodeRepositoryService: friendCodeRepositoryService,
      );

  Stream<FriendCode> get onChanged;

  FriendCode get friendCode;
}

class _FriendCodeModelImpl implements FriendCodeModel {
  _FriendCodeModelImpl({
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
