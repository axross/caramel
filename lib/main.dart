import 'package:cloud_firestore/cloud_firestore.dart' show Firestore;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:firebase_analytics/firebase_analytics.dart'
    show FirebaseAnalytics;
import 'package:firebase_analytics/observer.dart'
    show FirebaseAnalyticsObserver;
import 'package:firebase_storage/firebase_storage.dart' show FirebaseStorage;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider;
import './entity/user.dart';
import './model/authentication_model.dart';
import './model_creator/friend_code_model_creator.dart';
import './model_creator/friend_list_model_creator.dart';
import './model_creator/new_friend_model_creator.dart';
import './screen/friend_list_screen.dart';
import './service/friend_code_scan_service.dart';
import './service/friend_repository_service.dart';

void main() {
  final analytics = FirebaseAnalytics();
  final auth = FirebaseAuth.instance;
  final database = Firestore.instance;
  final storage = FirebaseStorage.instance;
  final friendCodeScanService = FriendCodeScanService();
  final friendRepositoryService = FriendRepositoryService(database: database);

  auth.signInAnonymously();

  runApp(
    MyApp(
      analytics: analytics,
      auth: auth,
      database: database,
      storage: storage,
      friendCodeScanService: friendCodeScanService,
      friendRepositoryService: friendRepositoryService,
    ),
  );
}

class MyApp extends StatelessWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAuth auth;
  final Firestore database;
  final FirebaseStorage storage;
  final FriendCodeScanService friendCodeScanService;
  final FriendRepositoryService friendRepositoryService;

  MyApp({
    Key key,
    @required this.analytics,
    @required this.auth,
    @required this.database,
    @required this.storage,
    @required this.friendCodeScanService,
    @required this.friendRepositoryService,
  })  : assert(analytics != null),
        assert(auth != null),
        assert(database != null),
        assert(storage != null),
        assert(friendCodeScanService != null),
        assert(friendRepositoryService != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final authenticationModel = AuthenticationModel(
      auth: auth,
      database: database,
    );

    return Provider(
      value: FriendCodeModelCreator(database: database),
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
    );
  }
}
