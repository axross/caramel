import 'package:caramel/entities.dart';
import 'package:caramel/models.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

class FriendCodeModelCreator {
  FriendCodeModelCreator(
      {@required FriendCodeRepositoryService friendCodeRepositoryService})
      : assert(friendCodeRepositoryService != null),
        _friendCodeRepositoryService = friendCodeRepositoryService;

  final FriendCodeRepositoryService _friendCodeRepositoryService;

  FriendCodeModel createModel(User user) => FriendCodeModel(
        user: user,
        friendCodeRepositoryService: _friendCodeRepositoryService,
      );
}
