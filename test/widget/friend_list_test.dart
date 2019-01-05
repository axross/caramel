import 'package:caramel/widgets.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../mock/entities.dart';
import '../mock/model_creators.dart';
import '../mock/models.dart';

void main() {
  testWidgets('', (tester) async {
    final authenticationModel = TestAuthenticationModel();
    when(authenticationModel.onUserChanged).thenAnswer(
      (_) => Stream.fromIterable([
            TestUser(),
          ]),
    );
    when(authenticationModel.user).thenReturn(TestUser());

    final chatByFriendshipModel = TestChatByFriendshipModel();
    when(chatByFriendshipModel.onChanged).thenAnswer(
      (_) => Stream.fromFuture(
            Future.value(
              TestChat(),
            ),
          ),
    );
    when(chatByFriendshipModel.chat).thenReturn(TestChat());

    final chatByFriendshipModelCreator = TestChatByFriendshipModelCreator();
    when(
      chatByFriendshipModelCreator.createModel(
        user: anyNamed('user'),
        friendship: anyNamed('friendship'),
      ),
    ).thenReturn(chatByFriendshipModel);

    final friendListModel = TestFriendListModel();
    when(friendListModel.friendships).thenReturn([
      TestFriendship.fromUser(TestUser(name: 'Elton John')),
      TestFriendship.fromUser(TestUser(name: 'Collin Firth')),
    ]);
    when(friendListModel.onChanged).thenAnswer(
      (_) => Stream.fromFuture(
            Future.value([
              TestFriendship.fromUser(TestUser(name: 'Elton John')),
              TestFriendship.fromUser(TestUser(name: 'Collin Firth')),
              TestFriendship.fromUser(TestUser(name: 'Gabriel Mackt')),
            ]),
          ),
    );

    await tester.pumpWidget(
      Provider<AuthenticationModel>(
        value: authenticationModel,
        child: Provider<ChatByFriendshipModelCreator>(
          value: chatByFriendshipModelCreator,
          child: Provider<FriendListModel>(
            value: friendListModel,
            child: MaterialApp(
              home: Material(
                child: FriendList(),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Elton John'), findsNothing);
    expect(find.text('Collin Firth'), findsNothing);
    expect(find.text('Gabriel Mackt'), findsNothing);

    await tester.pump();

    expect(find.text('Elton John'), findsOneWidget);
    expect(find.text('Collin Firth'), findsOneWidget);
    expect(find.text('Gabriel Mackt'), findsNothing);

    await tester.pump();

    expect(find.text('Elton John'), findsOneWidget);
    expect(find.text('Collin Firth'), findsOneWidget);
    expect(find.text('Gabriel Mackt'), findsOneWidget);
  });
}
