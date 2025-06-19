// lib/features/profile/providers/profile_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primero/features/home/providers/home_di.dart'; // 이 경로는 올바릅니다.
import 'package:primero/features/home/repositories/home_repository.dart'; // 이 경로는 올바릅니다.
import '../repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileRepository _profileRepository;
  final HomeRepository _homeRepository;
  final Ref _ref; // Ref를 멤버 변수로 저장하여 다른 Provider에 접근 가능

  ProfileNotifier(this._profileRepository, this._homeRepository, this._ref)
      : super(const ProfileState.initial()) {
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    state = const ProfileState.loading();
    try {
      final userProfile = await _profileRepository.getUserProfile();
      final authLogs = await _profileRepository.getAuthLogs(userProfile.userId);
      state = ProfileState.loaded(userProfile, authLogs);
    } catch (e) {
      state = ProfileState.error(e.toString());
    }
  }

  Future<bool> updateProfileData({
    required String newNickname,
  }) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return false;

    final user = currentState.userProfile;
    state = const ProfileState.loading();
    try {
      // 사용자 정보와 캐릭터 닉네임을 동시에 업데이트 (병렬 호출)
      await Future.wait([
        _profileRepository.updateUserProfile(
          userId: user.userId,
          newTreeName: newNickname,
        ),
        _homeRepository.updateNickname(newNickname),
      ]);

      await loadUserProfile(); // 프로필 데이터 새로고침
      _ref.read(homeNotifierProvider.notifier).fetchHomeData(); // 홈 화면 데이터도 새로고침

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