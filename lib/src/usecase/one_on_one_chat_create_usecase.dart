import 'package:caramel/domains.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

/// A callable usecase to create an one-on-one [Chat].
class OneOnOneChatCreateUsecase {
  /// Creates an [OneOnOneChatCreateUsecase].
  OneOnOneChatCreateUsecase({@required ChatRepository chatRepository})
      : assert(chatRepository != null),
        _chatRepository = chatRepository;

  ChatRepository _chatRepository;

  /// Creates an one-on-one [Chat] between [hero] and [opponent].
  void call({@required SignedInUser hero, @required User opponent}) =>
      _chatRepository.createOneOnOneChat(
        hero: hero,
        opponent: opponent,
      );
}
