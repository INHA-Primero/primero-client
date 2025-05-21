// lib/features/auth/data/sources/local/auth_local_data_source.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthLocalDataSource {
  Future<void> saveTokens({required String accessToken, String? refreshToken});
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> deleteTokens();

  Future<void> saveDeviceUuid(String uuid);
  Future<String?> getDeviceUuid();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage _secureStorage;

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _deviceUuidKey =
      'device_uuid'; // DeviceUuidService와 동일한 키 사용

  AuthLocalDataSourceImpl({required FlutterSecureStorage secureStorage})
    : _secureStorage = secureStorage;

  @override
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _accessTokenKey);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _secureStorage.write(key: _accessTokenKey, value: accessToken);
    if (refreshToken != null) {
      await _secureStorage.write(key: _refreshTokenKey, value: refreshToken);
    }
  }

  @override
  Future<void> deleteTokens() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
    // device_uuid는 로그아웃 시 삭제하지 않는 것이 일반적입니다.
    // 앱을 삭제하거나 사용자가 명시적으로 기기 등록 해제 등을 할 때 삭제합니다.
  }

  @override
  Future<String?> getDeviceUuid() async {
    return await _secureStorage.read(key: _deviceUuidKey);
  }

  @override
  Future<void> saveDeviceUuid(String uuid) async {
    // 이 메서드는 DeviceUuidService에서 주로 사용되지만,
    // 일관성을 위해 AuthLocalDataSource에도 포함할 수 있습니다.
    await _secureStorage.write(key: _deviceUuidKey, value: uuid);
  }
}
