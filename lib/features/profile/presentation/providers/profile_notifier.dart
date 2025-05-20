// lib/features/profile/presentation/providers/profile_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primero/features/profile/domain/entities/user_profile_entity.dart';
import 'package:primero/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:primero/features/profile/domain/usecases/update_user_profile_usecase.dart';
import 'package:primero/features/profile/domain/usecases/change_password_usecase.dart';
import 'profile_state.dart';

// TODO: 실제 userId 로직으로 대체 필요
// const String _tempCurrentUserId = "user123";

class ProfileNotifier extends StateNotifier<ProfileState> {
  final GetUserProfileUseCase _getUserProfileUseCase;
  final UpdateUserProfileUseCase _updateUserProfileUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;
  // final String _userId; // 생성자를 통해 실제 userId를 받는 것이 좋습니다.

  ProfileNotifier({
    required GetUserProfileUseCase getUserProfileUseCase,
    required UpdateUserProfileUseCase updateUserProfileUseCase,
    required ChangePasswordUseCase changePasswordUseCase,
    // required String userId,
  }) : _getUserProfileUseCase = getUserProfileUseCase,
       _updateUserProfileUseCase = updateUserProfileUseCase,
       _changePasswordUseCase = changePasswordUseCase,
       // _userId = userId,
       super(ProfileInitial()) {
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    // 현재 상태가 이미 로딩 중이거나, 업데이트 중이 아닐 때만 로드 (중복 로드 방지)
    if (state is ProfileLoading ||
        state is ProfileInfoUpdating ||
        state is PasswordChangeLoading)
      return;
    state = ProfileLoading();
    try {
      final profile = await _getUserProfileUseCase.call();
      state = ProfileLoaded(profile);
    } catch (e) {
      state = ProfileError(e.toString());
    }
  }

  Future<void> updateProfileInfo({
    String? nickname,
    String? profileImageUrl,
  }) async {
    final currentState = state;
    UserProfileEntity? currentProfileData;

    if (currentState is ProfileLoaded) {
      // ProfileLoaded 또는 이를 상속하는 모든 상태
      currentProfileData = currentState.userProfile;
    }

    if (currentProfileData == null) {
      state = const ProfileError("프로필 정보가 로드되지 않아 업데이트할 수 없습니다.");
      return;
    }

    // 실제 변경 사항이 있는지 확인
    bool hasChanges =
        (nickname != null && nickname != currentProfileData.nickname) ||
        (profileImageUrl != null &&
            profileImageUrl != currentProfileData.profileImageUrl) ||
        (profileImageUrl == null &&
            currentProfileData.profileImageUrl != null); // 이미지 삭제 요청

    if (!hasChanges) {
      state = ProfileInfoUpdateSuccess(
        currentProfileData,
        successMessage: "변경사항이 없습니다.",
      );
      return;
    }

    state = ProfileInfoUpdating(currentProfileData);

    try {
      final updatedProfile = await _updateUserProfileUseCase.call(
        UpdateUserProfileParams(
          nickname: nickname,
          profileImageUrl: profileImageUrl,
        ),
      );
      state = ProfileInfoUpdateSuccess(updatedProfile);
      // 성공 후 바로 ProfileLoaded로 변경하여 UI가 최신 데이터를 반영하도록 함
      // state = ProfileLoaded(updatedProfile); // 이렇게 하면 SnackBar 트리거가 어려울 수 있음
    } catch (e) {
      state = ProfileInfoUpdateFailure(currentProfileData, e.toString());
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = PasswordChangeLoading();
    try {
      await _changePasswordUseCase.call(
        ChangePasswordParams(
          currentPassword: currentPassword,
          newPassword: newPassword,
        ),
      );
      state = const PasswordChangeSuccess();
      // 비밀번호 변경 성공 후, 보안을 위해 프로필 정보를 다시 로드할 수도 있습니다.
      // 또는 단순히 성공 메시지만 표시하고, 사용자가 프로필 화면으로 돌아갔을 때
      // 최신 정보가 필요하다면 (예: 마지막 비밀번호 변경일 표시) 그때 로드합니다.
      // loadUserProfile();
    } catch (e) {
      state = PasswordChangeFailure(e.toString());
    }
  }
}
