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
  StatefulStream<FriendCode> call({@required SignedInUser hero}) =>
      StatefulStream(
        _friendCodeRepository.subscribeNewestFriendCode(hero: hero),
      );
}
