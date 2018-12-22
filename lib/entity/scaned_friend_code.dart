import './friend_code.dart';

class ScanedFriendCode extends FriendCode {
  ScanedFriendCode._(String code) : super(code);

  ScanedFriendCode factory ScanedFriendCode.parseScanedData(String maybeCode) {
    if (!regexp.hasMatch(maybeCode)) {
      throw FriendCodeParsingFailure(maybeCode);
    }

    return ScanedFriendCode._(maybeCode);
  }

  static final regexp = RegExp(r'^[\x00-\x7F]{30}$');
}

class FriendCodeParsingFailure implements Exception {
  String code;

  FriendCodeParsingFailure(this.code);

  String toString() => 'FriendCodeParsingFailure: "$code" is not a valid code.';
}
