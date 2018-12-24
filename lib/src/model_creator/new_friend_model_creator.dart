import 'package:caramel/entity.dart';
import 'package:caramel/model.dart';
import 'package:caramel/service.dart';
import 'package:meta/meta.dart';

class NewFriendModelCreator {
  NewFriendModelCreator({
    @required FriendCodeScanService friendCodeScanService,
    @required FriendRepositoryService friendRepositoryService,
  })  : assert(friendCodeScanService != null),
        assert(friendRepositoryService != null),
        _friendCodeScanService = friendCodeScanService,
        _friendRepositoryService = friendRepositoryService;

  final FriendCodeScanService _friendCodeScanService;
  final FriendRepositoryService _friendRepositoryService;

  NewFriendModel createModel(User user) => NewFriendModel(
        user,
        friendCodeScanService: _friendCodeScanService,
        friendRepositoryService: _friendRepositoryService,
      );
}
