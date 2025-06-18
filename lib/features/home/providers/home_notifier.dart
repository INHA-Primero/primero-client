import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primero/features/home/models/character_info_model.dart';
import 'package:primero/features/home/repositories/home_repository.dart';
import 'package:primero/features/profile/models/user_profile_model.dart';
import 'package:primero/features/profile/repositories/profile_repository.dart';
import 'home_state.dart';

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
      // 사용자 정보와 캐릭터 정보를 병렬로 가져옵니다.
      final profileFuture = _profileRepository.getUserProfile();
      final characterFuture = _homeRepository.getCharacterInfo();

      // 두 API 호출이 모두 완료될 때까지 기다립니다.
      final results = await Future.wait([profileFuture, characterFuture]);

      final userProfile = results[0] as UserProfileModel;
      final characterInfo = results[1] as CharacterInfoModel;
      // --------------------------

      state = HomeState.loaded(
        userProfile: userProfile,
        characterInfo: characterInfo,
      );
    } catch (e) {
      state = HomeState.error('홈 화면 데이터를 불러오는데 실패했습니다: ${e.toString()}');
    }
  }
}
