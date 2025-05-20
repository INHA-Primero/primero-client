// lib/features/profile/data/repositories/profile_repository_impl.dart

import 'package:primero/features/profile/data/models/user_profile_model.dart';
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
    // password는 여기서 받지 않음. changePassword 메서드로 분리.
  }) async {
    final Map<String, dynamic> dataToUpdate = {};
    if (nickname != null) dataToUpdate['nickname'] = nickname;
    if (profileImageUrl != null)
      dataToUpdate['profileImageUrl'] = profileImageUrl;
    // profileImageUrl을 null로 설정하고 싶다면, API 명세에 따라 명시적으로 null을 보내야 할 수 있습니다.
    // 예: dataToUpdate['profileImageUrl'] = null; (값이 null이 아니거나, 명시적으로 null로 업데이트할 때)

    // 변경할 내용이 없는 경우에 대한 처리는 UseCase나 Notifier에서 하는 것이 더 적절할 수 있습니다.
    // 현재는 remoteDataSource.updateUserProfile이 빈 Map도 처리한다고 가정합니다.
    if (dataToUpdate.isEmpty && profileImageUrl == null) {
      // 명시적으로 null로 업데이트하는 경우도 고려
      // 이 경우 API를 호출하지 않거나, 현재 정보를 반환할 수 있습니다.
      // 여기서는 API 호출로 넘깁니다.
    }

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
}
