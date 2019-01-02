import 'package:caramel/widgets.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import '../mock/entities.dart';
import '../mock/model_creators.dart';
import '../mock/models.dart';

void main() {
  testWidgets('', (tester) async {
    final AuthenticationModel authenticationModel = TestAuthenticationModel();
    when(authenticationModel.onUserChanged).thenAnswer(
      (_) => Stream.fromIterable([
            TestUser(),
          ]),
    );
    when(authenticationModel.user).thenReturn(TestUser());

    final ChatByFriendshipModel chatByFriendshipModel =
        TestChatByFriendshipModel();
    when(chatByFriendshipModel.onChanged).thenAnswer(
      (_) => Stream.fromFuture(
            Future.value(
              TestChat(),
            ),
          ),
    );
    when(chatByFriendshipModel.chat).thenReturn(TestChat());

    final ChatByFriendshipModelCreator chatByFriendshipModelCreator =
        TestChatByFriendshipModelCreator();
    when(
      chatByFriendshipModelCreator.createModel(
        user: anyNamed('user'),
        friendship: anyNamed('friendship'),
      ),
    ).thenReturn(chatByFriendshipModel);

    final FriendListModel friendListModel = TestFriendListModel();
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
      Provider(
        value: authenticationModel,
        child: Provider(
          value: chatByFriendshipModelCreator,
          child: Provider(
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
