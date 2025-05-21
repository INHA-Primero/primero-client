// lib/features/profile/presentation/providers/profile_notifier.dart
import 'dart:io'; // File 사용을 위해 추가
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primero/features/profile/domain/entities/user_profile_entity.dart';
import 'package:primero/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:primero/features/profile/domain/usecases/update_user_profile_usecase.dart';
import 'package:primero/features/profile/domain/usecases/change_password_usecase.dart';
import 'package:primero/features/profile/domain/usecases/upload_profile_image_usecase.dart'; // 추가
import 'profile_state.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  final GetUserProfileUseCase _getUserProfileUseCase;
  final UpdateUserProfileUseCase _updateUserProfileUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;
  final UploadProfileImageUseCase _uploadProfileImageUseCase; // 추가

  // TODO: 실제 사용자 ID를 생성자나 다른 Provider를 통해 주입받아야 합니다.
  // final String _userId;

  ProfileNotifier({
    required GetUserProfileUseCase getUserProfileUseCase,
    required UpdateUserProfileUseCase updateUserProfileUseCase,
    required ChangePasswordUseCase changePasswordUseCase,
    required UploadProfileImageUseCase uploadProfileImageUseCase, // 추가
    // required String userId, // 예시: 사용자 ID 주입
  }) : _getUserProfileUseCase = getUserProfileUseCase,
       _updateUserProfileUseCase = updateUserProfileUseCase,
       _changePasswordUseCase = changePasswordUseCase,
       _uploadProfileImageUseCase = uploadProfileImageUseCase, // 초기화
       // _userId = userId, // 초기화
       super(ProfileInitial()) {
    loadUserProfile();
  }

  /// 프로필 정보를 불러옵니다.
  Future<void> loadUserProfile() async {
    // 이미 로딩 중이거나 전체 프로필 업데이트 중이면 중복 실행 방지
    if (state is ProfileLoading || state is ProfileFullUpdating) return;
    state = ProfileLoading();
    try {
      final profile =
          await _getUserProfileUseCase.call(); // userId가 필요하다면 파라미터로 전달
      state = ProfileLoaded(profile);
    } catch (e) {
      state = ProfileError(e.toString());
    }
  }

  /// 프로필 정보 (닉네임 및/또는 새 이미지 파일)를 업데이트합니다.
  Future<void> updateProfileData({
    File? newImageFile, // 사용자가 새로 선택한 이미지 파일 (null일 수 있음)
    String? newNickname, // 사용자가 입력한 새 닉네임 (null일 수 있음)
  }) async {
    final currentState = state;
    UserProfileEntity? currentProfileData;

    // 현재 프로필 데이터 가져오기 (ProfileLoaded 또는 이를 상속한 상태에서만 가능)
    if (currentState is ProfileLoaded) {
      currentProfileData = currentState.userProfile;
    } else {
      // 프로필 정보가 로드되지 않은 상태에서는 업데이트 시도 불가
      state = const ProfileError(
        "프로필 정보가 로드되지 않아 업데이트할 수 없습니다. 먼저 프로필 정보를 로드해주세요.",
      );
      return;
    }

    // 실제 변경 사항이 있는지 확인
    // 닉네임이 실제로 변경되었는지, 또는 새 이미지가 선택되었는지 확인
    bool isNicknameChanged =
        newNickname != null &&
        newNickname.trim().isNotEmpty &&
        newNickname.trim() != currentProfileData.nickname;
    bool isImageChanged = newImageFile != null;

    if (!isNicknameChanged && !isImageChanged) {
      // 변경 사항이 없으면 사용자에게 알리고 현재 상태 유지 (또는 특정 메시지 없이 ProfileLoaded로)
      state = ProfileInfoUpdateSuccess(
        currentProfileData,
        successMessage: "변경사항이 없습니다.",
      );
      return;
    }

    // 업데이트 시작 상태 (UI에 로딩 표시 등을 위해 기존 프로필 정보와 함께 전달)
    state = ProfileFullUpdating(currentProfileData);

    String? finalImageUrl =
        currentProfileData.profileImageUrl; // 기본적으로 현재 이미지 URL 사용

    try {
      // 1. 새 이미지 파일이 있다면 서버에 업로드하고 결과 URL을 받습니다.
      if (isImageChanged) {
        finalImageUrl = await _uploadProfileImageUseCase.call(newImageFile!);
      }

      // 2. 닉네임 또는 이미지 URL(새로 업로드되었거나 기존 URL)을 사용하여 프로필 정보 업데이트
      // 닉네임이 변경되지 않았다면 기존 닉네임을 사용합니다.
      final String nicknameToUpdate =
          (isNicknameChanged
              ? newNickname!.trim()
              : currentProfileData.nickname);

      final updatedProfile = await _updateUserProfileUseCase.call(
        UpdateUserProfileParams(
          nickname: nicknameToUpdate,
          profileImageUrl:
              finalImageUrl, // 업로드된 새 URL 또는 기존 URL (null일 수도 있음 - 이미지 삭제/기본값)
        ),
      );
      state = ProfileInfoUpdateSuccess(updatedProfile); // 최종 성공 상태
    } catch (e) {
      // 에러 발생 시, 이전 프로필 정보(currentProfileData)와 함께 실패 상태로 전환
      state = ProfileInfoUpdateFailure(
        currentProfileData,
        "프로필 업데이트 실패: ${e.toString()}",
      );
    }
  }

  /// 비밀번호를 변경합니다.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = PasswordChangeLoading(); // 비밀번호 변경 중 상태
    try {
      await _changePasswordUseCase.call(
        ChangePasswordParams(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ),
      );
      state = const PasswordChangeSuccess();
      // 성공 후, 보안을 위해 프로필 정보를 다시 로드하거나,
      // 사용자에게 로그아웃 후 재로그인을 유도할 수도 있습니다.
      // loadUserProfile(); // 필요에 따라 주석 해제
    } catch (e) {
      state = PasswordChangeFailure(e.toString());
    }
  }
}
