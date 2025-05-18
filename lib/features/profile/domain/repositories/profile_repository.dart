// lib/features/profile/domain/repositories/profile_repository.dart

import 'package:primero/features/profile/domain/entities/user_profile_entity.dart';

abstract class ProfileRepository {
  Future<UserProfileEntity> getUserProfile();

  Future<UserProfileEntity> updateUserProfile({
    String? nickname, // 이름(name)은 수정 불가, 닉네임(나무이름)만
    String? profileImageUrl,
  });

  /// 비밀번호를 변경합니다.
  Future<void> changePassword({
    // 반환 타입은 성공 여부만 알려주거나, UserProfileEntity를 다시 받을 수도 있음
    required String currentPassword,
    required String newPassword,
  });
}
