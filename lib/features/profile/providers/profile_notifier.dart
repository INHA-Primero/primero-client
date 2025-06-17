// lib/features/profile/providers/profile_notifier.dart

import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileNotifier(this._profileRepository)
    : super(const ProfileState.initial()) {
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    state = const ProfileState.loading();
    try {
      // 1. 사용자 프로필 정보를 먼저 가져옵니다.
      final userProfile = await _profileRepository.getUserProfile();
      // 2. 가져온 프로필의 userId를 사용하여 인증 기록을 가져옵니다.
      final authLogs = await _profileRepository.getAuthLogs(userProfile.userId);
      // 3. 두 데이터를 모두 포함하여 `loaded` 상태로 변경합니다.
      state = ProfileState.loaded(userProfile, authLogs);
    } catch (e) {
      state = ProfileState.error(e.toString());
    }
  }

  Future<bool> updateProfileData({
    required String newNickname,
    File? newImageFile,
  }) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return false;

    final user = currentState.userProfile;
    state = const ProfileState.loading();
    try {
      await _profileRepository.updateUserProfile(
        userId: user.userId,
        newTreeName: newNickname,
        newImageFile: newImageFile,
      );
      await loadUserProfile(); // 성공 후 최신 정보 다시 로드
      return true;
    } catch (e) {
      state = ProfileState.error(e.toString(), previousProfile: user);
      return false;
    }
  }

  Future<bool> changePassword({required String newPassword}) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return false;

    final user = currentState.userProfile;
    state = const ProfileState.loading();
    try {
      await _profileRepository.changePassword(
        userId: user.userId,
        newPassword: newPassword,
        currentTreeName: user.treeName,
      );
      await loadUserProfile();
      return true;
    } catch (e) {
      state = ProfileState.error(e.toString(), previousProfile: user);
      return false;
    }
  }
}
