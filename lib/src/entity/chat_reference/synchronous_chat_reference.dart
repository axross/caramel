import 'dart:async';
import 'package:caramel/entities.dart';

class SynchronousChatReference implements ChatReference {
  SynchronousChatReference.fromChat(
    Chat chat,
  )   : assert(chat != null),
        _chat = chat;

  final Chat _chat;

  @override
  Future<Chat> resolve() => Future.value(_chat);
}
