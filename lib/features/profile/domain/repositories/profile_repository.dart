// lib/features/profile/domain/repositories/profile_repository.dart
import 'dart:io'; // File 사용을 위해 추가
import 'package:primero/features/profile/domain/entities/user_profile_entity.dart';

abstract class ProfileRepository {
  Future<UserProfileEntity> getUserProfile();

  Future<UserProfileEntity> updateUserProfile({
    String? nickname,
    String? profileImageUrl, // null 가능 (이미지 삭제/기본값 요청 시)
  });

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// 이미지 파일을 업로드하고 결과 URL을 반환합니다.
  Future<String> uploadProfileImage(File imageFile);
}
