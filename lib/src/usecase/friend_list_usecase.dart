import 'package:caramel/domains.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

/// A callable usecase to retrieve the [Friendship]s.
class FriendListUsecase {
  /// Creates a [FriendListUsecase].
  FriendListUsecase({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  UserRepository _userRepository;

  /// Retrieve the [Friendship]s what the [hero] has.
  FriendshipsObservable call({@required SignedInUser hero}) =>
      _FriendshipsObservable(
        hero: hero,
        userRepository: _userRepository,
      );
}

class _FriendshipsObservable implements FriendshipsObservable {
  _FriendshipsObservable({
    @required SignedInUser hero,
    @required UserRepository userRepository,
  })  : assert(hero != null),
        assert(userRepository != null),
        _hero = hero,
        _userRepository = userRepository;

  final SignedInUser _hero;

  final UserRepository _userRepository;

  @override
  Stream<Iterable<Friendship>> get onChanged =>
      _userRepository.subscribeFriendships(hero: _hero)
        ..listen((friendships) {
          _friendships = friendships;
        });

  Iterable<Friendship> _friendships;

  @override
  Iterable<Friendship> get latest => _friendships;
}
