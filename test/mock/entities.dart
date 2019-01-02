import 'package:caramel/entities.dart';

const _loremIpsum =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod '
    'tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim '
    'veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea '
    'commodo consequat.';

class TestUser implements User {
  TestUser({
    this.uid = '00000000000000000000',
    this.name = 'Test User',
    Uri imageUrl,
  }) : imageUrl = imageUrl ?? Uri();

  @override
  final String uid;
  @override
  final String name;
  @override
  final Uri imageUrl;
}

class TestChat with ChatStruct, ToReferenceMixin implements Chat {
  TestChat({
    this.id = '',
    Iterable<UserReference> members,
    ChatMessageReference lastChatMessage,
  })  : members = members ?? [],
        lastChatMessage = lastChatMessage ?? TestChatMessageReference();

  @override
  final String id;
  @override
  final Iterable<UserReference> members;
  @override
  final ChatMessageReference lastChatMessage;
}

class TestChatMessageReference implements ChatMessageReference {
  TestChatMessageReference({ChatMessage chatMessage})
      : chatMessage = chatMessage ?? TestChatMessage();

  final ChatMessage chatMessage;

  @override
  Future<ChatMessage> resolve() => Future.value(chatMessage);
}

class TestChatMessage implements ChatMessage {
  TestChatMessage({
    UserReference from,
    DateTime sentAt,
    Iterable<UserReference> readBy,
    this.text = _loremIpsum,
  })  : from = from ?? TestUserReference(),
        sentAt = sentAt ?? DateTime.utc(2019, 1, 1),
        readBy = readBy ?? [];

  @override
  final UserReference from;
  @override
  final DateTime sentAt;
  @override
  final Iterable<UserReference> readBy;
  final String text;
}

class TestFriendship implements Friendship {
  TestFriendship({UserReference user}) : user = user ?? TestUserReference();
  TestFriendship.fromUser(User user) : user = TestUserReference(user: user);

  @override
  final UserReference user;
}

class TestUserReference implements UserReference {
  TestUserReference({User user}) : user = user ?? TestUser();

  final User user;

  @override
  bool isSameUser(User user) => user.uid == this.user.uid;

  @override
  Future<User> resolve() => Future.value(user);
}
