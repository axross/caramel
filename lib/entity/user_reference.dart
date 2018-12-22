import './user.dart';

abstract class UserReference {
  Future<User> resolve();
}
