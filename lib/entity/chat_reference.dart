import './chat.dart';

abstract class ChatReference {
  Future<Chat> resolve();
}
