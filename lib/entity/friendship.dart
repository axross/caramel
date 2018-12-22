import 'package:meta/meta.dart';
import './chat_reference.dart';
import './user_reference.dart';

abstract class Friendship {
  final UserReference user;
  final ChatReference chat;

  Friendship({
    @required this.user,
    @required this.chat,
  })  : assert(user != null),
        assert(chat != null);
}
