import 'dart:io';
import 'package:dio/dio.dart'; // DioException을 사용하기 위해 import
import '../data_sources/profile_remote_data_source.dart';
import '../models/recycle_history_model.dart';
import '../models/user_profile_model.dart';
import '../models/user_modify_request_model.dart';

class ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepository(this._remoteDataSource);

  Future<UserProfileModel> getUserProfile() {
    return _remoteDataSource.getUserProfile();
  }

  Future<void> updateUserProfile({
    required int userId,
    required String newTreeName,
  }) {
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

  // ✨ 수정: 무한 루프 방지를 위한 에러 처리 로직 추가
  Future<PageRecycleListResponse> getRecycleHistory({
    required int page,
    required int size,
  }) async {
    try {
      return await _remoteDataSource.getRecycleHistory(page: page, size: size);
    } on DioException catch (e) {
      // 서버 응답이 있고, 상태 코드가 404 Not Found일 경우 (데이터가 없을 때)
      if (e.response?.statusCode == 404) {
        // 에러를 던지는 대신, '비어있는 성공' 응답 객체를 생성하여 반환합니다.
        // 이렇게 하면 UI는 에러가 아닌 빈 목록으로 상태를 인지하게 됩니다.
        return const PageRecycleListResponse(
          content: [],
          totalPages: 0,
          totalElements: 0,
          last: true,
          size: 0,
          number: 0,
          numberOfElements: 0,
          first: true,
          empty: true,
        );
      }
      // 404가 아닌 다른 에러(서버 다운 등)는 그대로 다시 던져서 상위에서 처리하도록 합니다.
      rethrow;
    }
  }

  Future<RecycleDetail> getRecycleDetail({required int id}) {
    return _remoteDataSource.getRecycleDetail(id: id);
  }
}
