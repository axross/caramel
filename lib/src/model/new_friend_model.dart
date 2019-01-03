import 'dart:async';
import 'package:caramel/entities.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

/// A model managing the list of [Friendship]s the user participated in.
///
/// When the instance doesn't need anymore, [dispose()] should be called.
abstract class NewFriendModel {
  /// Creates a [NewFriendModel].
  factory NewFriendModel({
    @required User user,
    @required FriendCodeScanService friendCodeScanService,
    @required FriendRepositoryService friendRepositoryService,
  }) =>
      _NewFriendModel(
        user: user,
        friendCodeScanService: friendCodeScanService,
        friendRepositoryService: friendRepositoryService,
      );

  /// The sink to request scanning a QR with device's camera.
  Sink<void> get scanRequest;

  /// Closes all [Sink]s used in the instance. This method should be called
  /// when the instance doesn't need anymore.
  void dispose();
}

class _NewFriendModel implements NewFriendModel {
  _NewFriendModel({
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
