import 'package:cloud_firestore/cloud_firestore.dart' show Firestore;
import 'package:meta/meta.dart';
import '../entity/user.dart';
import '../model/friend_code_model.dart';

class FriendCodeModelCreator {
  final Firestore database;

  FriendCodeModelCreator({@required this.database}) : assert(database != null);

  FriendCodeModel createModel(User user) =>
      FriendCodeModel(user, database: database);
}
