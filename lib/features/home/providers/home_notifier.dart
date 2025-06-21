// lib/features/home/providers/home_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primero/features/home/repositories/home_repository.dart';
import 'package:primero/features/profile/repositories/profile_repository.dart';
import 'package:primero/features/profile/models/user_profile_model.dart';
import 'package:primero/features/home/models/character_info_model.dart';
import 'home_state.dart'; // home_state.dart가 올바른 위치에 있는지 확인

class HomeNotifier extends StateNotifier<HomeState> {
  final ProfileRepository _profileRepository;
  final HomeRepository _homeRepository;

  HomeNotifier(this._profileRepository, this._homeRepository)
    : super(const HomeState.initial()) {
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    state = const HomeState.loading();
    try {
      // API 병렬 호출
      final results = await Future.wait([
        _profileRepository.getUserProfile(),
        _homeRepository.getCharacterInfo(),
      ]);

      final profile = results[0] as UserProfileModel;
      final character = results[1] as CharacterInfoModel;

      // fetchHomeData가 호출되면 isWatering은 항상 false로 초기화됩니다.
      state = HomeState.loaded(
        userProfile: profile,
        characterInfo: character,
        isWatering: false,
      ); // isWatering이 false인지 확인
    } catch (e) {
      state = HomeState.error('홈 화면 데이터를 불러오는데 실패했습니다: ${e.toString()}');
    }
  }

  Future<bool> updateNickname(String nickname) async {
    state = const HomeState.loading();
    try {
      await _homeRepository.updateNickname(nickname);
      await fetchHomeData(); // 성공 후 데이터 새로고침
      return true;
    } catch (e) {
      state = HomeState.error('닉네임 변경에 실패했습니다: ${e.toString()}');
      await fetchHomeData();
      return false;
    }
  }

  Future<void> waterCharacter() async {
    // maybeWhen을 사용하여 'loaded' 상태일 때만 로직 실행
    // isWatering을 초기화할 때 HomeState.loaded를 사용 (copyWith 대신)
    state.maybeWhen(
      loaded: (userProfile, characterInfo, isWatering) async {
        if (characterInfo.wateringChance > 0) {
          // 1. 애니메이션 시작을 위해 isWatering 상태를 true로 변경
          // 새로운 HomeState.loaded 객체 생성
          state = HomeState.loaded(
            userProfile: userProfile,
            characterInfo: characterInfo,
            isWatering: true,
          );

          try {
            // 2. API 호출과 애니메이션 최소 재생 시간(예: 2초)을 동시에 기다림
            await Future.wait([
              _homeRepository.waterCharacter(),
              Future.delayed(
                const Duration(seconds: 2),
              ), // 애니메이션이 보이도록 최소 2초 대기
            ]);

            // 3. 성공 후 최신 데이터를 다시 불러와 화면을 갱신 (isWatering은 자동으로 false가 됨)
            await fetchHomeData();
          } catch (e) {
            // 에러 발생 시, 애니메이션을 멈추고 원래 상태로 복귀
            state = HomeState.loaded(
              // 에러 발생 시 isWatering을 다시 false로 설정
              userProfile: userProfile,
              characterInfo: characterInfo,
              isWatering: false,
            );
            state = HomeState.error('물주기에 실패했습니다: ${e.toString()}');
            fetchHomeData(); // 에러 후에도 데이터 새로고침
          }
        } else {
          // 물주기 기회가 없는 경우 처리 (예: 스낵바 메시지)
          // 현재 상태를 유지하거나 특정 메시지를 표시할 수 있습니다.
        }
      },
      orElse: () {
        // loaded 상태가 아닐 때 waterCharacter가 호출된 경우 처리
        // 예: 로딩 중이거나 에러 상태일 때 물주기 시도 시 아무것도 하지 않음
      },
    );
  }
}
