// lib/features/profile/repositories/profile_repository.dart

import 'dart:io';
import '../data_sources/profile_remote_data_source.dart';
import '../models/auth_log_res.dart'; // ✨ 인증 로그 모델 import
import '../models/user_profile_model.dart';
import '../models/user_modify_request_model.dart';

class ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepository(this._remoteDataSource);

  Future<UserProfileModel> getUserProfile() {
    return _remoteDataSource.getUserProfile();
  }

  // ✨ 인증 로그를 가져오는 메서드 추가
  Future<List<AuthLogRes>> getAuthLogs(int userId) {
    return _remoteDataSource.getAuthLogs(userId);
  }

  Future<void> updateUserProfile({
    required int userId,
    required String newTreeName,
    File? newImageFile,
  }) async {
    final request = UserModifyRequestModel(treeName: newTreeName);
    return _remoteDataSource.updateUserProfile(userId, request);
  }

  Future<void> changePassword({
    required int userId,
    required String newPassword,
    required String currentTreeName,
  }) {
    final request = UserModifyRequestModel(
      treeName: currentTreeName,
      password: newPassword,
    );
    return _remoteDataSource.updateUserProfile(userId, request);
  }
}
