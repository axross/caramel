import 'package:caramel/domains.dart';
import 'package:caramel/routes.dart';
import 'package:caramel/usecases.dart';
import 'package:caramel/widgets.dart';
import 'package:firebase_analytics/firebase_analytics.dart'
    show FirebaseAnalytics;
import 'package:firebase_analytics/observer.dart'
    show FirebaseAnalyticsObserver;
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({
    @required this.analytics,
    @required this.authenticate,
    @required this.deleteFriendship,
    @required this.listChat,
    @required this.participateChat,
    @required this.getFriendCode,
    @required this.createFriend,
    @required this.listFriend,
    Key key,
  })  : assert(analytics != null),
        assert(authenticate != null),
        assert(deleteFriendship != null),
        assert(listChat != null),
        assert(participateChat != null),
        assert(getFriendCode != null),
        assert(createFriend != null),
        assert(listFriend != null),
        super(key: key);

  final FirebaseAnalytics analytics;
  final AuthenticateUsecase authenticate;
  final FriendshipDeleteUsecase deleteFriendship;
  final ChatListUsecase listChat;
  final ChatParticipateUsecase participateChat;
  final FriendCodeGetUsecase getFriendCode;
  final FriendCreateUsecase createFriend;
  final FriendListUsecase listFriend;

  @override
  Widget build(BuildContext context) => MemoizedBuilder(
        valueBuilder: (context, old) => old ?? authenticate(),
        builder: (context, heroObservable) => Provider(
              value: deleteFriendship,
              child: Provider(
                value: listChat,
                child: Provider(
                  value: participateChat,
                  child: Provider(
                    value: getFriendCode,
                    child: Provider(
                      value: createFriend,
                      child: Provider(
                        value: listFriend,
                        child: StreamBuilder<User>(
                          stream: heroObservable.onChanged,
                          initialData: heroObservable.latest,
                          builder: (_, snapshot) => snapshot.hasData
                              ? MaterialApp(
                                  title: 'Flutter Demo',
                                  theme: ThemeData(
                                    primarySwatch: Colors.blue,
                                  ),
                                  initialRoute: '/',
                                  routes: {
                                    '/': HomeRoute(hero: snapshot.requireData)
                                        .builder,
                                  },
                                  navigatorObservers: [
                                    FirebaseAnalyticsObserver(
                                      analytics: analytics,
                                    ),
                                  ],
                                )
                              : Container(
                                  decoration:
                                      const BoxDecoration(color: Colors.red),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
      );
}
