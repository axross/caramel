import 'package:caramel/entities.dart';
import 'package:caramel/models.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

class ChatByFriendshipModelCreator {
  ChatByFriendshipModelCreator({
    @required ChatRepositoryService chatRepositoryService,
  })  : assert(chatRepositoryService != null),
        _chatRepositoryService = chatRepositoryService;

  final ChatRepositoryService _chatRepositoryService;

  ChatByFriendshipModel createModel({
    @required User user,
    @required Friendship friendship,
  }) =>
      ChatByFriendshipModel(
        user: user,
        friendship: friendship,
        chatRepositoryService: _chatRepositoryService,
      );
}
