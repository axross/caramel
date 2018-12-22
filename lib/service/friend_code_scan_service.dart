import 'package:barcode_scan/barcode_scan.dart';
import '../entity/friend_code.dart';
import '../entity/scaned_friend_code.dart';

class FriendCodeScanService {
  Future<FriendCode> scan() async {
    String data;

    try {
      data = await BarcodeScanner.scan();
    } catch (error) {
      throw ScanCancelled();
    }

    return ScanedFriendCode.parseScanedData(data);
  }
}

class ScanCancelled implements Exception {
  ScanCancelled();

  String toString() => 'ScanCancelled: scaning barcode has been cancelled.';
}
