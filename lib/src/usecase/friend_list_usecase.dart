import 'package:caramel/domains.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

/// A callable usecase to retrieve the [Friendship]s.
class FriendListUsecase {
  /// Creates a [FriendListUsecase].
  FriendListUsecase({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  final UserRepository _userRepository;

  /// Retrieve the [Friendship]s what the [hero] has.
  StatefulStream<List<Friendship>> call({@required SignedInUser hero}) =>
      StatefulStream(_userRepository.subscribeFriendships(hero: hero));
}
