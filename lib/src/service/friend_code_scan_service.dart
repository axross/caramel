import 'package:caramel/entities.dart';
import 'package:barcode_scan/barcode_scan.dart';

/// A service to scan [FriendCode] QR codes.
abstract class FriendCodeScanService {
  /// Creates a [FriendCodeScanService].
  factory FriendCodeScanService() => _FriendCodeScanService();

  /// Scans QR code with device's camera.
  Future<FriendCode> scan();
}

class _FriendCodeScanService implements FriendCodeScanService {
  @override
  Future<FriendCode> scan() async {
    String data;

    try {
      data = await BarcodeScanner.scan();
    } on Exception catch (_) {
      throw ScanCancelled();
    }

    return FriendCode.parse(data);
  }
}

///
class ScanCancelled implements Exception {
  ///
  ScanCancelled();

  @override
  String toString() => 'ScanCancelled: scaning barcode has been cancelled.';
}
