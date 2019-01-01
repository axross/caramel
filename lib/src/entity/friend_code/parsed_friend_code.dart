import 'package:caramel/entities.dart';

class ParsedFriendCode implements FriendCode {
  factory ParsedFriendCode.parse(String maybeCode) {
    if (!RegExp(r'^[0-9A-Za-z_\-]{20}$').hasMatch(maybeCode)) {
      throw FriendCodeParsingFailure(maybeCode);
    }

    return ParsedFriendCode._(maybeCode);
  }

  ParsedFriendCode._(this.code);

  @override
  final String code;
}

class FriendCodeParsingFailure implements Exception {
  FriendCodeParsingFailure(this.code);

  String code;

  @override
  String toString() => 'FriendCodeParsingFailure: "$code" is not a valid code.';
}
