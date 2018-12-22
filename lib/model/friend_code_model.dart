import 'package:meta/meta.dart';
import '../entity/friend_code.dart';
import '../entity/user.dart';
import '../service/friend_code_repository_service.dart';

class FriendCodeModel {
  final FriendCodeRepositoryService _friendCodeRepositoryService;
  final User _user;
  FriendCode _friendCode;

  FriendCodeModel(User user,
      {@required FriendCodeRepositoryService friendCodeRepositoryService})
      : assert(friendCodeRepositoryService != null),
        assert(user != null),
        _friendCodeRepositoryService = friendCodeRepositoryService,
        _user = user;

  Stream<FriendCode> get onChanged =>
      _friendCodeRepositoryService.subscribeNewestFriendCode(_user)
        ..listen((friendCode) {
          _friendCode = friendCode;
        });

  FriendCode get friendCode => _friendCode;
}
