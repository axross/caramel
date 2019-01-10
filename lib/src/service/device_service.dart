import 'dart:io';
import 'package:caramel/domains.dart';
import 'package:device_info/device_info.dart';

abstract class DeviceService {
  factory DeviceService() => _DeviceService();

  Future<DeviceInformation> get deviceInformation;
}

class _DeviceService implements DeviceService {
  _DeviceService() : _deviceInfoPlugin = DeviceInfoPlugin();

  final DeviceInfoPlugin _deviceInfoPlugin;

  @override
  Future<DeviceInformation> get deviceInformation async {
    if (Platform.isIOS) {
      return IosDeviceInformation(await _deviceInfoPlugin.iosInfo);
    }

    if (Platform.isAndroid) {
      return AndroidDeviceInformation(await _deviceInfoPlugin.androidInfo);
    }

    throw new Exception();
  }
}
