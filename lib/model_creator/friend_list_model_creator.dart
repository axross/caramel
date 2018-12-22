import 'package:meta/meta.dart';
import '../entity/user.dart';
import '../model/friend_list_model.dart';
import '../service/friend_repository_service.dart';

class FriendListModelCreator {
  final FriendRepositoryService _friendRepositoryService;

  FriendListModelCreator({
    @required FriendRepositoryService friendRepositoryService,
  })  : assert(friendRepositoryService != null),
        _friendRepositoryService = friendRepositoryService;

  FriendListModel createModel(User user) =>
      FriendListModel(user, friendRepositoryService: _friendRepositoryService);
}
