import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primero/features/home/providers/home_di.dart';
import 'package:primero/features/home/repositories/home_repository.dart';
import '../repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileRepository _profileRepository;
  final HomeRepository _homeRepository;
  final Ref _ref;

  ProfileNotifier(this._profileRepository, this._homeRepository, this._ref)
    : super(const ProfileState.initial()) {
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    state = const ProfileState.loading();
    try {
      // getAuthLogs 호출 로직 제거
      final userProfile = await _profileRepository.getUserProfile();
      state = ProfileState.loaded(userProfile);
    } catch (e) {
      state = ProfileState.error(e.toString());
    }
  }

  Future<bool> updateProfileData({required String newNickname}) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return false;

    final user = currentState.userProfile;
    state = ProfileState.loading();
    try {
      await Future.wait([
        _profileRepository.updateUserProfile(
          userId: user.userId,
          newTreeName: newNickname,
        ),
        _homeRepository.updateNickname(newNickname),
      ]);

      await loadUserProfile();
      _ref.read(homeNotifierProvider.notifier).fetchHomeData();

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
