import 'package:caramel/services.dart';
import 'package:caramel/usecases.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show Firestore;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:firebase_analytics/firebase_analytics.dart'
    show FirebaseAnalytics;
import 'package:flutter/material.dart';
import './src/app.dart';

void main() {
  final analytics = FirebaseAnalytics();
  final auth = FirebaseAuth.instance;
  final firestore = Firestore.instance;

  final authenticator = FirebaseAuthenticator(auth: auth);
  final chatRepository = FirestoreChatRepository(firestore);
  final friendCodeRepository = FirestoreFriendCodeRepository(firestore);
  final friendCodeScanner = FriendCodeScanner();
  final userRepository = FirestoreUserRepository(firestore);

  final authenticate = AuthenticateUsecase(
    authenticator: authenticator,
    userRepository: userRepository,
  );
  final deleteFriendship =
      FriendshipDeleteUsecase(userRepository: userRepository);
  final listChat = ChatListUsecase(chatRepository: chatRepository);
  final participateChat = ChatParticipateUsecase(
    chatRepository: chatRepository,
  );
  final getFriendCode = FriendCodeGetUsecase(
    friendCodeRepository: friendCodeRepository,
  );
  final createFriend = FriendCreateUsecase(
    friendCodeScanner: friendCodeScanner,
    userRepository: userRepository,
  );
  final listFriend = FriendListUsecase(userRepository: userRepository);

  runApp(
    App(
      analytics: analytics,
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
