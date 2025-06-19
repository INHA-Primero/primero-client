// lib/features/profile/repositories/profile_repository.dart

import 'dart:io';
import '../data_sources/profile_remote_data_source.dart';
import '../models/auth_log_res.dart';
import '../models/user_profile_model.dart';
import '../models/user_modify_request_model.dart';

class ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepository(this._remoteDataSource);

  Future<UserProfileModel> getUserProfile() {
    return _remoteDataSource.getUserProfile();
  }

  Future<List<AuthLogRes>> getAuthLogs(int userId) {
    return _remoteDataSource.getAuthLogs(userId);
  }
  
  // ✨ updateUserProfile에서 이미지 파일 관련 로직 제거
  Future<void> updateUserProfile({
    required int userId,
    required String newTreeName,
  }) async {
    // API 명세에 따라 UserModifyRequestModel에는 treeName만 전달
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