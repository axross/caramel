import 'package:caramel/entities.dart';
import 'package:caramel/models.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

class ChatListModelCreator {
  ChatListModelCreator({
    @required ChatRepositoryService chatRepositoryService,
  })  : assert(chatRepositoryService != null),
        _chatRepositoryService = chatRepositoryService;

  final ChatRepositoryService _chatRepositoryService;

  ChatListModel createModel({@required User user}) => ChatListModel(
        user: user,
        chatRepositoryService: _chatRepositoryService,
      );
}
