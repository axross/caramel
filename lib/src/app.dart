import 'package:caramel/domains.dart';
import 'package:caramel/routes.dart';
import 'package:caramel/usecases.dart';
import 'package:firebase_analytics/firebase_analytics.dart'
    show FirebaseAnalytics;
import 'package:firebase_analytics/observer.dart'
    show FirebaseAnalyticsObserver;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider;

class App extends StatefulWidget {
  const App({
    @required this.analytics,
    @required this.authenticate,
    @required this.listChat,
    @required this.participateChat,
    @required this.getFriendCode,
    @required this.createFriend,
    @required this.listFriend,
    @required this.createOneOnOneChat,
    Key key,
  })  : assert(analytics != null),
        assert(authenticate != null),
        assert(listChat != null),
        assert(participateChat != null),
        assert(getFriendCode != null),
        assert(createFriend != null),
        assert(listFriend != null),
        assert(createOneOnOneChat != null),
        super(key: key);

  final FirebaseAnalytics analytics;
  final AuthenticateUsecase authenticate;
  final ChatListUsecase listChat;
  final ChatParticipateUsecase participateChat;
  final FriendCodeGetUsecase getFriendCode;
  final FriendCreateUsecase createFriend;
  final FriendListUsecase listFriend;
  final OneOnOneChatCreateUsecase createOneOnOneChat;

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  SignedInUserObservable _heroObservable;

  @override
  void initState() {
    super.initState();

    _heroObservable = widget.authenticate();
  }

  @override
  Widget build(BuildContext context) => Provider(
        value: widget.listChat,
        child: Provider(
          value: widget.participateChat,
          child: Provider(
            value: widget.getFriendCode,
            child: Provider(
              value: widget.createFriend,
              child: Provider(
                value: widget.listFriend,
                child: Provider(
                  value: widget.createOneOnOneChat,
                  child: StreamBuilder<User>(
                    stream: _heroObservable.onChanged,
                    initialData: _heroObservable.latest,
                    builder: (_, snapshot) => snapshot.hasData
                        ? MaterialApp(
                            title: 'Flutter Demo',
                            theme: ThemeData(
                              primarySwatch: Colors.blue,
                            ),
                            initialRoute: '/',
                            routes: {
                              '/':
                                  HomeRoute(hero: snapshot.requireData).builder,
                            },
                            navigatorObservers: [
                              FirebaseAnalyticsObserver(
                                analytics: widget.analytics,
                              ),
                            ],
                          )
                        : Container(
                            decoration: const BoxDecoration(color: Colors.red),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
