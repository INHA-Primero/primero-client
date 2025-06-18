// lib/features/profile/providers/profile_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/auth_log_res.dart'; // ✨ 인증 로그 모델 import
import '../models/user_profile_model.dart';

part 'profile_state.freezed.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState.initial() = _Initial;
  const factory ProfileState.loading() = _Loading;
  // ✨ `loaded` 상태에 List<AuthLogRes> authLogs 추가
  const factory ProfileState.loaded(
    UserProfileModel userProfile,
    List<AuthLogRes> authLogs,
  ) = ProfileLoaded;
  const factory ProfileState.error(
    String message, {
    UserProfileModel? previousProfile,
  }) = _Error;
}
