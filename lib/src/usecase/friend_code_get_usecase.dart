import 'package:caramel/domains.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

/// A callable usecase to get [FriendCode]s.
class FriendCodeGetUsecase {
  /// Creates a [FriendCodeGetUsecase].
  FriendCodeGetUsecase({@required FriendCodeRepository friendCodeRepository})
      : assert(friendCodeRepository != null),
        _friendCodeRepository = friendCodeRepository;

  final FriendCodeRepository _friendCodeRepository;

  /// Gets the available [FriendCode].
  FriendCodeObservable call({@required SignedInUser hero}) =>
      _FriendCodeObservable(
        hero: hero,
        friendCodeRepository: _friendCodeRepository,
      )..onChanged.listen((friendCode) {
          if (friendCode == null) {
            _friendCodeRepository.create(hero: hero);
          }
        });
}

class _FriendCodeObservable implements FriendCodeObservable {
  _FriendCodeObservable({
    @required SignedInUser hero,
    @required FriendCodeRepository friendCodeRepository,
  })  : assert(hero != null),
        assert(friendCodeRepository != null),
        _hero = hero,
        _friendCodeRepository = friendCodeRepository;

  final SignedInUser _hero;

  final FriendCodeRepository _friendCodeRepository;

  @override
  Stream<FriendCode> get onChanged =>
      _friendCodeRepository.subscribeNewestFriendCode(hero: _hero)
        ..listen((friendCode) {
          _friendCode = friendCode;
        });

  FriendCode _friendCode;

  @override
  FriendCode get latest => _friendCode;
}
