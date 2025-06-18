import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:primero/features/home/models/character_info_model.dart';
import 'package:primero/features/profile/models/user_profile_model.dart';

part 'home_state.freezed.dart';

// 홈 화면에 필요한 모든 데이터를 담는 상태 클래스입니다.
@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;
  const factory HomeState.loading() = _Loading;
  const factory HomeState.loaded({
    required UserProfileModel userProfile,
    required CharacterInfoModel characterInfo,
  }) = _Loaded;
  const factory HomeState.error(String message) = _Error;
}
