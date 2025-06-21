import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class DeviceUuidService {
  final FlutterSecureStorage _secureStorage;
  final Uuid _uuid;
  static const String _deviceUuidKey = 'device_uuid';

  DeviceUuidService({
    required FlutterSecureStorage secureStorage,
    required Uuid uuid,
  }) : _secureStorage = secureStorage,
       _uuid = uuid;

  Future<String> getOrCreateDeviceUuid() async {
    String? deviceUuid = await _secureStorage.read(key: _deviceUuidKey);

    if (deviceUuid == null || deviceUuid.isEmpty) {
      deviceUuid = _uuid.v4();
      await _secureStorage.write(key: _deviceUuidKey, value: deviceUuid);
      print('New device_uuid created and saved: $deviceUuid');
    } else {
      print('Existing device_uuid loaded: $deviceUuid');
    }
    return deviceUuid;
  }

  Future<String?> getDeviceUuid() async {
    return await _secureStorage.read(key: _deviceUuidKey);
  }

  Future<void> deleteDeviceUuid() async {
    await _secureStorage.delete(key: _deviceUuidKey);
    print('Device_uuid deleted.');
  }
}
