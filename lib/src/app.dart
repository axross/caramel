import 'package:caramel/domains.dart';
import 'package:caramel/routes.dart';
import 'package:caramel/services.dart';
import 'package:caramel/usecases.dart';
import 'package:caramel/widgets.dart';
import 'package:firebase_analytics/firebase_analytics.dart'
    show FirebaseAnalytics;
import 'package:firebase_analytics/observer.dart'
    show FirebaseAnalyticsObserver;
import 'package:flutter/material.dart';

class App extends StatefulWidget {
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
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) => MemoizedBuilder(
        valueBuilder: (context, old) => old ?? widget.authenticate(),
        builder: (context, heroObservable) => Provider(
              value: widget.deleteFriendship,
              child: Provider(
                value: widget.listChat,
                child: Provider(
                  value: widget.participateChat,
                  child: Provider(
                    value: widget.getFriendCode,
                    child: Provider(
                      value: widget.createFriend,
                      child: Provider(
                        value: widget.listFriend,
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
                                      analytics: widget.analytics,
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
