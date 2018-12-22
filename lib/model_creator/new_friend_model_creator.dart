import 'package:meta/meta.dart';
import '../entity/user.dart';
import '../model/new_friend_model.dart';
import '../service/friend_code_scan_service.dart';
import '../service/friend_repository_service.dart';

class NewFriendModelCreator {
  final FriendCodeScanService _friendCodeScanService;
  final FriendRepositoryService _friendRepositoryService;

  NewFriendModelCreator({
    @required FriendCodeScanService friendCodeScanService,
    @required FriendRepositoryService friendRepositoryService,
  })  : assert(friendCodeScanService != null),
        assert(friendRepositoryService != null),
        _friendCodeScanService = friendCodeScanService,
        _friendRepositoryService = friendRepositoryService;

  NewFriendModel createModel(User user) => NewFriendModel(
        user,
        friendCodeScanService: _friendCodeScanService,
        friendRepositoryService: _friendRepositoryService,
      );
}
