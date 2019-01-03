import 'package:caramel/entities.dart';
import 'package:caramel/models.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

/// A model creator for [NewFriendModel]. This encapsulates the dependencies of
/// the model and provides the way to create a model with providing the
/// dependencies.
class NewFriendModelCreator {
  /// Creates a [NewFriendModel].
  NewFriendModelCreator({
    @required FriendCodeScanService friendCodeScanService,
    @required FriendRepositoryService friendRepositoryService,
  })  : assert(friendCodeScanService != null),
        assert(friendRepositoryService != null),
        _friendCodeScanService = friendCodeScanService,
        _friendRepositoryService = friendRepositoryService;

  final FriendCodeScanService _friendCodeScanService;
  final FriendRepositoryService _friendRepositoryService;

  /// Creates [NewFriendModel]. Almost all of dependencies will be provided.
  NewFriendModel createModel(User user) => NewFriendModel(
        user: user,
        friendCodeScanService: _friendCodeScanService,
        friendRepositoryService: _friendRepositoryService,
      );
}
