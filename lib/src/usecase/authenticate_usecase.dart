import 'package:caramel/domains.dart';
import 'package:caramel/services.dart';
import 'package:meta/meta.dart';

/// A callable usecase to authenticate an user.
class AuthenticateUsecase {
  /// Creates an [AuthenticateUsecase].
  AuthenticateUsecase({
    @required Authenticator authenticator,
    @required UserRepository userRepository,
  })  : assert(authenticator != null),
        assert(userRepository != null),
        _authenticator = authenticator,
        _userRepository = userRepository;

  final Authenticator _authenticator;

  final UserRepository _userRepository;

  /// Authenticates an user.
  SignedInUserObservable call() {
    _authenticator.signIn();

    return _SignedInUserObservable(
        _authenticator.observeSignedInUserId().asyncMap((id) async {
      if (id == null) {
        return null;
      }

      final user = _userRepository.referByFirebaseAuthId(id: id);

      try {
        return await user.resolve;
      } on UserNotExisting catch (_) {
        await _userRepository.registerUser(user: user);

        return await user.resolve;
      }
    }));
  }
}

class _SignedInUserObservable implements SignedInUserObservable {
  _SignedInUserObservable(this._onChanged) : assert(_onChanged != null);

  final Stream<SignedInUser> _onChanged;

  @override
  Stream<SignedInUser> get onChanged => _onChanged
    ..listen((signedInUser) {
      _signedInUser = signedInUser;
    });

  SignedInUser _signedInUser;

  @override
  SignedInUser get latest => _signedInUser;
}
