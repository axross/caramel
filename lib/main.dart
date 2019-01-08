import 'package:caramel/services.dart';
import 'package:caramel/usecases.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show Firestore;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:firebase_analytics/firebase_analytics.dart'
    show FirebaseAnalytics;
import 'package:flutter/material.dart';
import 'package:onesignal/onesignal.dart';
import './src/app.dart';

void main() {
  final analytics = FirebaseAnalytics();
  final auth = FirebaseAuth.instance;
  final firestore = Firestore.instance;

  final atomicWriteCreator = FirestoreAtomicWriteCreator(firestore: firestore);
  final authenticator = FirebaseAuthenticator(auth: auth);
  final chatRepository = FirestoreChatRepository(firestore);
  final friendCodeRepository = FirestoreFriendCodeRepository(firestore);
  final friendCodeScanner = FriendCodeScanner();
  final notificationManager = OnesignalFirestoreNotificationManager(
    onesignal: OneSignal(),
    appId: 'b7b4abd6-7ce0-44a9-af56-00e80125779e',
    firestore: firestore,
  );
  final userRepository = FirestoreUserRepository(firestore);

  final authenticate = AuthenticateUsecase(
    authenticator: authenticator,
    userRepository: userRepository,
  );
  final deleteFriendship = FriendshipDeleteUsecase(
    atomicWriteCreator: atomicWriteCreator,
    chatRepository: chatRepository,
    notificationManager: notificationManager,
    userRepository: userRepository,
  );
  final listChat = ChatListUsecase(chatRepository: chatRepository);
  final participateChat = ChatParticipateUsecase(
    chatRepository: chatRepository,
  );
  final getFriendCode = FriendCodeGetUsecase(
    friendCodeRepository: friendCodeRepository,
  );
  final createFriend = FriendCreateUsecase(
    atomicWriteCreator: atomicWriteCreator,
    chatRepository: chatRepository,
    friendCodeRepository: friendCodeRepository,
    friendCodeScanner: friendCodeScanner,
    notificationManager: notificationManager,
    userRepository: userRepository,
  );
  final listFriend = FriendListUsecase(userRepository: userRepository);

  runApp(
    App(
      analytics: analytics,
      notificationManager: notificationManager,
      authenticate: authenticate,
      deleteFriendship: deleteFriendship,
      listChat: listChat,
      participateChat: participateChat,
      getFriendCode: getFriendCode,
      createFriend: createFriend,
      listFriend: listFriend,
    ),
  );
}
