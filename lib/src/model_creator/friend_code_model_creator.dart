import 'package:caramel/entities.dart';
import 'package:caramel/models.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

/// A model creator for [FriendCodeModel]. This encapsulates the dependencies of
/// the model and provides the way to create a model with providing the
/// dependencies.
class FriendCodeModelCreator {
  /// Creates a [FriendCodeModel].
  FriendCodeModelCreator({
    @required FriendCodeRepositoryService friendCodeRepositoryService,
  })  : assert(friendCodeRepositoryService != null),
        _friendCodeRepositoryService = friendCodeRepositoryService;

  final FriendCodeRepositoryService _friendCodeRepositoryService;

  /// Creates [FriendCodeModel]. Almost all of dependencies will be provided.
  FriendCodeModel createModel(User user) => FriendCodeModel(
        user: user,
        friendCodeRepositoryService: _friendCodeRepositoryService,
      );
}
