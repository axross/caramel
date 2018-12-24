import 'package:caramel/entities.dart';
import 'package:caramel/models.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

class ChatModelCreator {
  ChatModelCreator({
    @required ChatMessageRepositoryService chatMessageRepositoryService,
  })  : assert(chatMessageRepositoryService != null),
        _chatMessageRepositoryService = chatMessageRepositoryService;

  final ChatMessageRepositoryService _chatMessageRepositoryService;

  ChatModel createModel({
    @required Chat chat,
    @required User user,
  }) =>
      ChatModel(
        chat: chat,
        user: user,
        chatMessageRepositoryService: _chatMessageRepositoryService,
      );
}
