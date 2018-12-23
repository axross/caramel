import './user.dart';

abstract class UserReference {
  Future<User> resolve();
  bool isSameUser(User user);
  bool operator ==(Object other);
  int get hashCode;
}
