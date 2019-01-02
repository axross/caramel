import 'dart:async';
import 'package:caramel/entities.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

abstract class NewFriendModel {
  factory NewFriendModel({
    @required User user,
    @required FriendCodeScanService friendCodeScanService,
    @required FriendRepositoryService friendRepositoryService,
  }) =>
      _NewFriendModelImpl(
        user: user,
        friendCodeScanService: friendCodeScanService,
        friendRepositoryService: friendRepositoryService,
      );

  Sink<void> get scanRequest;

  void dispose();
}

class _NewFriendModelImpl implements NewFriendModel {
  _NewFriendModelImpl({
    @required User user,
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

  final FriendCodeScanService _friendCodeScanService;
  final FriendRepositoryService _friendRepositoryService;
  final User _user;

  final StreamController<void> _scanRequest = StreamController();

  @override
  Sink<void> get scanRequest => _scanRequest.sink;

  @override
  void dispose() {
    _scanRequest.close();
  }
}
