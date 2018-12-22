import 'package:meta/meta.dart';
import '../entity/user.dart';
import '../model/friend_code_model.dart';
import '../service/friend_code_repository_service.dart';

class FriendCodeModelCreator {
  final FriendCodeRepositoryService _friendCodeRepositoryService;

  FriendCodeModelCreator(
      {@required FriendCodeRepositoryService friendCodeRepositoryService})
      : assert(friendCodeRepositoryService != null),
        _friendCodeRepositoryService = friendCodeRepositoryService;

  FriendCodeModel createModel(User user) => FriendCodeModel(
        user,
        friendCodeRepositoryService: _friendCodeRepositoryService,
      );
}
