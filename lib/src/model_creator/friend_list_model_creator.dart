import 'package:caramel/entities.dart';
import 'package:caramel/models.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

/// A model creator for [FriendListModel]. This encapsulates the dependencies of
/// the model and provides the way to create a model with providing the
/// dependencies.
class FriendListModelCreator {
  /// Creates a [FriendListModel].
  FriendListModelCreator({
    @required FriendRepositoryService friendRepositoryService,
  })  : assert(friendRepositoryService != null),
        _friendRepositoryService = friendRepositoryService;

  final FriendRepositoryService _friendRepositoryService;

  /// Creates [FriendListModel]. Almost all of dependencies will be provided.
  FriendListModel createModel(User user) => FriendListModel(
        user: user,
        friendRepositoryService: _friendRepositoryService,
      );
}
