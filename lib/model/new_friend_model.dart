import 'dart:async';
import 'package:meta/meta.dart';
import '../entity/friend_code.dart';
import '../entity/user.dart';
import '../entity/database_user.dart';
import '../service/friend_code_scan_service.dart';
import '../service/friend_repository_service.dart';

class NewFriendModel {
  final FriendCodeScanService _friendCodeScanService;
  final FriendRepositoryService _friendRepositoryService;
  final User _user;

  // input
  final StreamController<void> _scanRequest = StreamController();

  NewFriendModel(
    User user, {
    @required FriendCodeScanService friendCodeScanService,
    @required FriendRepositoryService friendRepositoryService,
  })  : _friendCodeScanService = friendCodeScanService,
        _friendRepositoryService = friendRepositoryService,
        _user = user {
    _scanRequest.stream.listen((_) async {
      FriendCode friendCode;

      try {
        friendCode = await _friendCodeScanService.scan();
      } on ScanCancelled catch (__) {
        return;
      }

      await _friendRepositoryService.addByFriendCode(_user, friendCode);
    });
  }

  Sink<void> get scanRequest => _scanRequest.sink;

  void dispose() {
    _scanRequest.close();
  }
}
