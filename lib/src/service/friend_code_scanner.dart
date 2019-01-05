import 'package:caramel/domains.dart';
import 'package:barcode_scan/barcode_scan.dart';

/// A service to scan [FriendCode] QR codes.
abstract class FriendCodeScanner {
  /// Creates a [FriendCodeScanner].
  factory FriendCodeScanner() => _FriendCodeScanner();

  /// Scans QR code with device's camera.
  Future<ScannedFriendCode> scan();
}

class _FriendCodeScanner implements FriendCodeScanner {
  @override
  Future<ScannedFriendCode> scan() async {
    String data;

    try {
      data = await BarcodeScanner.scan();
    } on Exception catch (_) {
      throw ScanCancelled();
    }

    return ScannedFriendCode(data);
  }
}

class ScannedFriendCode implements FriendCode {
  factory ScannedFriendCode(String string) {
    if (!RegExp(r'^[0-9A-Za-z_\-]{20}$').hasMatch(string)) {
      throw FriendCodeParsingFailure(string);
    }

    return ScannedFriendCode._(string);
  }

  const ScannedFriendCode._(this.data);

  @override
  final String data;

  @override
  bool operator ==(Object other) =>
      other is ScannedFriendCode && other.hashCode == hashCode;

  @override
  int get hashCode => data.hashCode;
}

class FriendCodeParsingFailure implements Exception {
  /// Creates a [FriendCodeParsingFailure].
  const FriendCodeParsingFailure(this.data);

  /// A string.
  final String data;

  @override
  String toString() => 'FriendCodeParsingFailure: "$data" is not a valid code.';
}

///
class ScanCancelled implements Exception {
  ///
  ScanCancelled();

  @override
  String toString() => 'ScanCancelled: scaning barcode has been cancelled.';
}
