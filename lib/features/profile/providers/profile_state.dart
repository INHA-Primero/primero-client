import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/user_profile_model.dart';

part 'profile_state.freezed.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState.initial() = _Initial;
  const factory ProfileState.loading() = _Loading;

  // 분리수거 기록과 무관하게 프로필 정보만 관리하도록 수정합니다.
  const factory ProfileState.loaded(UserProfileModel userProfile) =
      ProfileLoaded;

  const factory ProfileState.error(
    String message, {
    UserProfileModel? previousProfile,
  }) = _Error;
}
