import 'package:caramel/entities.dart';
import 'package:caramel/models.dart';
import 'package:caramel/model_creators.dart';
import 'package:caramel/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show Firestore;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:firebase_analytics/firebase_analytics.dart'
    show FirebaseAnalytics;
import 'package:firebase_analytics/observer.dart'
    show FirebaseAnalyticsObserver;
import 'package:firebase_storage/firebase_storage.dart' show FirebaseStorage;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider;
import './screen_widget/friend_list_screen.dart';

class App extends StatelessWidget {
  const App({
    @required this.analytics,
    @required this.auth,
    @required this.firestore,
    @required this.storage,
    @required this.chatRepositoryService,
    @required this.friendCodeRepositoryService,
    @required this.friendCodeScanService,
    @required this.friendRepositoryService,
    Key key,
  })  : assert(analytics != null),
        assert(auth != null),
        assert(firestore != null),
        assert(storage != null),
        assert(chatRepositoryService != null),
        assert(friendCodeRepositoryService != null),
        assert(friendCodeScanService != null),
        assert(friendRepositoryService != null),
        super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAuth auth;
  final Firestore firestore;
  final FirebaseStorage storage;
  final ChatRepositoryService chatRepositoryService;
  final FriendCodeRepositoryService friendCodeRepositoryService;
  final FriendCodeScanService friendCodeScanService;
  final FriendRepositoryService friendRepositoryService;

  @override
  Widget build(BuildContext context) {
    final authenticationModel = AuthenticationModel(
      auth: auth,
      firestore: firestore,
    );

    return Provider(
      value: ChatByFriendshipModelCreator(
        chatRepositoryService: chatRepositoryService,
      ),
      child: Provider(
        value: ChatListModelCreator(
          chatRepositoryService: chatRepositoryService,
        ),
        child: Provider(
          value: ChatModelCreator(
            chatRepositoryService: chatRepositoryService,
          ),
          child: Provider(
            value: FriendCodeModelCreator(
              friendCodeRepositoryService: friendCodeRepositoryService,
            ),
            child: Provider(
              value: FriendListModelCreator(
                friendRepositoryService: friendRepositoryService,
              ),
              child: Provider(
                value: NewFriendModelCreator(
                  friendRepositoryService: friendRepositoryService,
                  friendCodeScanService: friendCodeScanService,
                ),
                child: Provider(
                  value: authenticationModel,
                  child: StreamBuilder<User>(
                    stream: authenticationModel.onUserChanged,
                    initialData: authenticationModel.user,
                    builder: (_, snapshot) => snapshot.data == null
                        ? Container()
                        : MaterialApp(
                            title: 'Flutter Demo',
                            theme: ThemeData(
                              primarySwatch: Colors.blue,
                            ),
                            initialRoute: '/',
                            routes: {
                              '/': (_) => FriendListScreen(),
                            },
                            navigatorObservers: [
                              FirebaseAnalyticsObserver(analytics: analytics),
                            ],
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
}
