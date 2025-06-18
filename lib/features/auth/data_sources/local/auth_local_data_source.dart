// lib/features/auth/data_sources/local/auth_local_data_source.dart
// 로그인 응답 변경에 맞춰 저장하는 데이터를 수정했습니다.

import 'package:shared_preferences/shared_preferences.dart';
// LoginResponseModel을 정확히 import 해야 합니다.
import '../../models/login_response_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveAuthData(LoginResponseModel response);
  Future<String?> getToken();
  Future<int?> getUserId();
  Future<void> clearAuthData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences _prefs;
  static const String _tokenKey = 'authToken';
  static const String _userIdKey = 'userId';
  static const String _treeNameKey = 'treeName';

  AuthLocalDataSourceImpl(this._prefs);

  @override
  Future<void> saveAuthData(LoginResponseModel response) async {
    await _prefs.setString(_tokenKey, response.token);
    await _prefs.setInt(_userIdKey, response.userId);
    await _prefs.setString(_treeNameKey, response.treeName);
  }

  @override
  Future<String?> getToken() async {
    return _prefs.getString(_tokenKey);
  }

  @override
  Future<int?> getUserId() async {
    return _prefs.getInt(_userIdKey);
  }

  @override
  Future<void> clearAuthData() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_treeNameKey);
  }
}
