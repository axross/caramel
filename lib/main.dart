import 'package:caramel/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show Firestore;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:firebase_analytics/firebase_analytics.dart'
    show FirebaseAnalytics;
import 'package:firebase_storage/firebase_storage.dart' show FirebaseStorage;
import 'package:flutter/material.dart';
import './src/app.dart';

void main() {
  final analytics = FirebaseAnalytics();
  final auth = FirebaseAuth.instance;
  final firestore = Firestore.instance;
  final storage = FirebaseStorage.instance;
  final chatRepositoryService = ChatRepositoryService.withFirestore(
    firestore: firestore,
  );
  final chatMessageRepositoryService =
      ChatMessageRepositoryService.withFirestore(
    firestore: firestore,
  );
  final friendCodeRepositoryService = FriendCodeRepositoryService.withFirestore(
    firestore: firestore,
  );
  final friendCodeScanService = FriendCodeScanService();
  final friendRepositoryService = FriendRepositoryService.withFirestore(
    firestore: firestore,
  );

  auth.signInAnonymously();

  runApp(
    App(
      analytics: analytics,
      auth: auth,
      firestore: firestore,
      storage: storage,
      chatMessageRepositoryService: chatMessageRepositoryService,
      chatRepositoryService: chatRepositoryService,
      friendCodeRepositoryService: friendCodeRepositoryService,
      friendCodeScanService: friendCodeScanService,
      friendRepositoryService: friendRepositoryService,
    ),
  );
}
