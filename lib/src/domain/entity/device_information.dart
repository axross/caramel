import 'package:device_info/device_info.dart';

abstract class DeviceInformation {
  String get id;

  String get manufacturer;

  String get model;

  String get os;

  String get osVersion;
}

class AndroidDeviceInformation implements DeviceInformation {
  AndroidDeviceInformation(AndroidDeviceInfo androidDeviceInfo)
      : assert(androidDeviceInfo != null),
        id = androidDeviceInfo.androidId,
        manufacturer = androidDeviceInfo.manufacturer,
        model = androidDeviceInfo.model,
        os = 'Android',
        osVersion = '${androidDeviceInfo.version.release}'
            '.${androidDeviceInfo.version.incremental}';

  @override
  final String id;

  @override
  final String manufacturer;

  @override
  final String model;

  @override
  final String os;

  @override
  final String osVersion;
}

class IosDeviceInformation implements DeviceInformation {
  IosDeviceInformation(IosDeviceInfo iosDeviceInfo)
      : assert(iosDeviceInfo != null),
        id = iosDeviceInfo.identifierForVendor,
        manufacturer = 'Apple',
        model = iosDeviceInfo.model,
        os = iosDeviceInfo.systemName,
        osVersion = iosDeviceInfo.systemVersion;

  @override
  final String id;

  @override
  final String manufacturer;

  @override
  final String model;

  @override
  final String os;

  @override
  final String osVersion;
}
