import 'package:caramel/entities.dart';
import 'package:caramel/models.dart';
import 'package:caramel/services.dart';
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
