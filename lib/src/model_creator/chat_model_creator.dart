import 'package:caramel/entities.dart';
import 'package:caramel/models.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

/// A model creator for [ChatModel]. This encapsulates the dependencies of the
/// model and provides the way to create a model with providing the
/// dependencies.
class ChatModelCreator {
  /// Creates a [ChatModel].
  ChatModelCreator({
    @required ChatRepositoryService chatRepositoryService,
  })  : assert(chatRepositoryService != null),
        _chatRepositoryService = chatRepositoryService;

  final ChatRepositoryService _chatRepositoryService;

  /// Creates [ChatModel]. Almost all of dependencies will be provided.
  ChatModel createModel({
    @required Chat chat,
    @required User user,
  }) =>
      ChatModel(
        chat: chat,
        user: user,
        chatRepositoryService: _chatRepositoryService,
      );
}
