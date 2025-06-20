import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:primero/features/home/models/character_info_model.dart';
import 'package:primero/features/profile/models/user_profile_model.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;
  const factory HomeState.loading() = _Loading;
  const factory HomeState.loaded({
    required UserProfileModel userProfile,
    required CharacterInfoModel characterInfo,
    @Default(false) bool isWatering, // ✨ isWatering 플래그 추가
  }) = _Loaded;
  const factory HomeState.error(String message) = _Error;
}
