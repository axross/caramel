import './friend_code.dart';

class ScanedFriendCode implements FriendCode {
  final String code;

  ScanedFriendCode factory ScanedFriendCode.parseScanedData(String maybeCode) {
    if (!RegExp(r'^[0-9A-Za-z_\-]{20}$').hasMatch(maybeCode)) {
      throw FriendCodeParsingFailure(maybeCode);
    }

    return ScanedFriendCode._(maybeCode);
  }

  ScanedFriendCode._(this.code);
}

class FriendCodeParsingFailure implements Exception {
  String code;

  FriendCodeParsingFailure(this.code);

  String toString() => 'FriendCodeParsingFailure: "$code" is not a valid code.';
}
