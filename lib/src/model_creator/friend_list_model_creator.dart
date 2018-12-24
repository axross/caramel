import 'package:caramel/entity.dart';
import 'package:caramel/model.dart';
import 'package:caramel/service.dart';
import 'package:meta/meta.dart';

class FriendListModelCreator {
  FriendListModelCreator({
    @required FriendRepositoryService friendRepositoryService,
  })  : assert(friendRepositoryService != null),
        _friendRepositoryService = friendRepositoryService;

  final FriendRepositoryService _friendRepositoryService;

  FriendListModel createModel(User user) =>
      FriendListModel(user, friendRepositoryService: _friendRepositoryService);
}
