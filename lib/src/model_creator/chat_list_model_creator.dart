import 'package:caramel/entities.dart';
import 'package:caramel/models.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

/// A model creator for [ChatListModel]. This encapsulates the dependencies of
/// the model and provides the way to create a model with providing the
/// dependencies.
class ChatListModelCreator {
  /// Creates a [ChatListModelCreator].
  ChatListModelCreator({
    @required ChatRepositoryService chatRepositoryService,
  })  : assert(chatRepositoryService != null),
        _chatRepositoryService = chatRepositoryService;

  final ChatRepositoryService _chatRepositoryService;

  /// Creates [ChatListModel]. Almost all of dependencies will be provided.
  ChatListModel createModel({@required User user}) => ChatListModel(
        user: user,
        chatRepositoryService: _chatRepositoryService,
      );
}
