// lib/features/profile/data/repositories/profile_repository_impl.dart
import 'dart:io'; // File 사용을 위해 추가
// import 'package:primero/features/profile/data/models/user_profile_model.dart'; // 이미 상단에 ProfileRemoteDataSource에서 import 되었으므로 중복 불필요
import 'package:primero/features/profile/data/sources/remote/profile_remote_data_source.dart';
import 'package:primero/features/profile/domain/entities/user_profile_entity.dart';
import 'package:primero/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserProfileEntity> getUserProfile() async {
    try {
      final userProfileModel = await remoteDataSource.fetchUserProfile();
      return userProfileModel.toEntity();
    } catch (e) {
      print('Error in ProfileRepositoryImpl.getUserProfile: $e');
      throw Exception('프로필 정보를 가져오는데 실패했습니다. ($e)');
    }
  }

  @override
  Future<UserProfileEntity> updateUserProfile({
    String? nickname,
    String? profileImageUrl,
  }) async {
    final Map<String, dynamic> dataToUpdate = {};
    bool hasChanges = false;

    if (nickname != null) {
      dataToUpdate['nickname'] = nickname;
      hasChanges = true;
    }
    // profileImageUrl은 명시적으로 null이 전달될 수도 있고, URL 문자열이 전달될 수도 있음.
    // 서버 API가 이를 적절히 처리한다고 가정.
    // profileImageUrl 필드 자체를 보내야 변경/삭제/유지 여부를 서버가 판단 가능.
    dataToUpdate['profileImageUrl'] = profileImageUrl;

    try {
      final updatedUserProfileModel = await remoteDataSource.updateUserProfile(
        dataToUpdate,
      );
      return updatedUserProfileModel.toEntity();
    } catch (e) {
      print('Error in ProfileRepositoryImpl.updateUserProfile: $e');
      throw Exception('프로필 업데이트에 실패했습니다. ($e)');
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    // 기존 구현과 동일
    try {
      await remoteDataSource.changePassword({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      });
    } catch (e) {
      print('Error in ProfileRepositoryImpl.changePassword: $e');
      throw Exception('비밀번호 변경에 실패했습니다. ($e)');
    }
  }

  @override
  Future<String> uploadProfileImage(File imageFile) async {
    try {
      // 데이터 소스 레이어에 이미지 업로드 요청 위임
      return await remoteDataSource.uploadProfileImage(imageFile);
    } catch (e) {
      print('Error in ProfileRepositoryImpl.uploadProfileImage: $e');
      // 여기서 에러를 좀 더 가공하거나, 특정 타입의 에러로 변환하여 상위 레이어로 전달할 수 있습니다.
      throw Exception('이미지 업로드에 실패했습니다. ($e)');
    }
  }
}
