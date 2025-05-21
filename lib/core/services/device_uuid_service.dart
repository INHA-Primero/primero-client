// lib/core/services/device_uuid_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

/// 디바이스의 고유 ID (UUID)를 관리하는 서비스입니다.
/// 앱 설치 시 한 번 생성되어 기기 내에 안전하게 저장되며,
/// 회원가입 또는 로그인 시 서버로 전송되어 기기를 식별하는 데 사용될 수 있습니다.
class DeviceUuidService {
  final FlutterSecureStorage _secureStorage;
  final Uuid _uuid;

  // SecureStorage에 device_uuid를 저장할 때 사용할 키
  static const String _deviceUuidKey = 'device_uuid';

  DeviceUuidService({
    required FlutterSecureStorage secureStorage,
    required Uuid uuid,
  }) : _secureStorage = secureStorage,
       _uuid = uuid;

  /// 저장된 device_uuid를 가져옵니다.
  /// 만약 저장된 UUID가 없다면 새로 생성하여 저장한 후 반환합니다.
  Future<String> getOrCreateDeviceUuid() async {
    String? deviceUuid = await _secureStorage.read(key: _deviceUuidKey);

    if (deviceUuid == null || deviceUuid.isEmpty) {
      // 저장된 UUID가 없으면 새로 생성
      deviceUuid = _uuid.v4(); // Version 4 UUID 생성
      await _secureStorage.write(key: _deviceUuidKey, value: deviceUuid);
      print('New device_uuid created and saved: $deviceUuid');
    } else {
      print('Existing device_uuid loaded: $deviceUuid');
    }
    return deviceUuid;
  }

  /// 현재 저장된 device_uuid를 반환합니다. (없으면 null)
  Future<String?> getDeviceUuid() async {
    return await _secureStorage.read(key: _deviceUuidKey);
  }

  /// 저장된 device_uuid를 삭제합니다. (주로 테스트 또는 특정 상황에서 사용)
  Future<void> deleteDeviceUuid() async {
    await _secureStorage.delete(key: _deviceUuidKey);
    print('Device_uuid deleted.');
  }
}
