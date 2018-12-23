import 'package:meta/meta.dart';
import '../entity/chat.dart';
import '../entity/user.dart';
import '../model/chat_model.dart';
import '../service/chat_message_repository_service.dart';

class ChatModelCreator {
  final ChatMessageRepositoryService _chatMessageRepositoryService;

  ChatModelCreator({
    @required ChatMessageRepositoryService chatMessageRepositoryService,
  })  : assert(chatMessageRepositoryService != null),
        _chatMessageRepositoryService = chatMessageRepositoryService;

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
