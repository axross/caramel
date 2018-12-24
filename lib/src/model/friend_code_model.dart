import 'package:caramel/entity.dart';
import 'package:caramel/service.dart';
import 'package:meta/meta.dart';

class FriendCodeModel {
  FriendCodeModel(User user,
      {@required FriendCodeRepositoryService friendCodeRepositoryService})
      : assert(friendCodeRepositoryService != null),
        assert(user != null),
        _friendCodeRepositoryService = friendCodeRepositoryService,
        _user = user;

  final FriendCodeRepositoryService _friendCodeRepositoryService;
  final User _user;
  FriendCode _friendCode;

  Stream<FriendCode> get onChanged =>
      _friendCodeRepositoryService.subscribeNewestFriendCode(_user)
        ..listen((friendCode) {
          _friendCode = friendCode;
        });

  FriendCode get friendCode => _friendCode;
}
