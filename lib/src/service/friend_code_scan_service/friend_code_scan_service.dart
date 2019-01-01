import 'package:caramel/entities.dart';
import 'package:barcode_scan/barcode_scan.dart';

class FriendCodeScanService {
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

class ScanCancelled implements Exception {
  ScanCancelled();

  @override
  String toString() => 'ScanCancelled: scaning barcode has been cancelled.';
}
