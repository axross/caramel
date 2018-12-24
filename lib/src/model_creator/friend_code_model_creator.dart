import 'package:caramel/entity.dart';
import 'package:caramel/model.dart';
import 'package:caramel/service.dart';
import 'package:meta/meta.dart';

class FriendCodeModelCreator {
  FriendCodeModelCreator(
      {@required FriendCodeRepositoryService friendCodeRepositoryService})
      : assert(friendCodeRepositoryService != null),
        _friendCodeRepositoryService = friendCodeRepositoryService;

  final FriendCodeRepositoryService _friendCodeRepositoryService;

  FriendCodeModel createModel(User user) => FriendCodeModel(
        user,
        friendCodeRepositoryService: _friendCodeRepositoryService,
      );
}
