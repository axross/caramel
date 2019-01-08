import 'package:caramel/domains.dart';
import 'package:caramel/routes.dart';
import 'package:caramel/services.dart';
import 'package:firebase_analytics/firebase_analytics.dart'
    show FirebaseAnalytics;
import 'package:firebase_analytics/observer.dart'
    show FirebaseAnalyticsObserver;
import 'package:flutter/material.dart';

class SignedIn extends StatefulWidget {
  SignedIn({
    @required SignedInUser hero,
    @required FirebaseAnalytics analytics,
    @required NotificationManager notificationManager,
  })  : assert(hero != null),
        assert(analytics != null),
        assert(notificationManager != null),
        _hero = hero,
        _analytics = analytics,
        _notificationManager = notificationManager;

  final SignedInUser _hero;
  final FirebaseAnalytics _analytics;
  final NotificationManager _notificationManager;

  @override
  State<StatefulWidget> createState() => _SignedInState();
}

class _SignedInState extends State<SignedIn> {
  GlobalObjectKey<NavigatorState> _navigatorKey;

  @override
  void initState() {
    super.initState();

    _navigatorKey = GlobalObjectKey(NavigatorState());

    widget._notificationManager.onChatMessageNotificationOpened
        .listen((notification) {
      _navigatorKey.currentState.push(ChatRoute(
        hero: widget._hero,
        chatId: notification.chat.substanceId,
      ));
    });
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        navigatorKey: _navigatorKey,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': HomeRoute(hero: widget._hero).builder,
        },
        navigatorObservers: [
          FirebaseAnalyticsObserver(
            analytics: widget._analytics,
          ),
        ],
      );
}
