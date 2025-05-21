// lib/features/profile/presentation/providers/profile_state.dart
import 'package:equatable/equatable.dart';
import 'package:primero/features/profile/domain/entities/user_profile_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {} // 프로필 정보 최초 로딩 시

class ProfileLoaded extends ProfileState {
  final UserProfileEntity userProfile;
  const ProfileLoaded(this.userProfile);
  @override
  List<Object?> get props => [userProfile];
}

class ProfileError extends ProfileState {
  final String message;
  final UserProfileEntity? previousProfile; // 오류 발생 시 이전 프로필 정보 (선택적)
  const ProfileError(this.message, {this.previousProfile});
  @override
  List<Object?> get props => [message, previousProfile];
}

/// 프로필 정보(닉네임 및/또는 이미지) 업데이트가 진행 중인 상태.
/// ProfileLoaded를 상속하여 현재 프로필 정보를 UI에 계속 표시할 수 있도록 함.
class ProfileFullUpdating extends ProfileLoaded {
  const ProfileFullUpdating(super.userProfile);
}

/// 프로필 정보(닉네임 및/또는 이미지) 업데이트 성공 상태.
class ProfileInfoUpdateSuccess extends ProfileLoaded {
  final String successMessage;
  const ProfileInfoUpdateSuccess(
    super.userProfile, {
    this.successMessage = "프로필 정보가 성공적으로 업데이트되었습니다.",
  });
  @override
  List<Object?> get props => [userProfile, successMessage];
}

/// 프로필 정보(닉네임 및/또는 이미지) 업데이트 실패 상태.
/// 실패하더라도 이전 프로필 정보를 유지하여 UI에 표시할 수 있도록 ProfileLoaded를 상속.
class ProfileInfoUpdateFailure extends ProfileLoaded {
  final String errorMessage;
  const ProfileInfoUpdateFailure(super.userProfile, this.errorMessage);
  @override
  List<Object?> get props => [userProfile, errorMessage];
}

// 비밀번호 변경 관련 상태 (기존과 동일)
class PasswordChangeInitial extends ProfileState {}

class PasswordChangeLoading extends ProfileState {} // 비밀번호 변경 중 로딩

class PasswordChangeSuccess extends ProfileState {
  final String successMessage;
  const PasswordChangeSuccess({this.successMessage = "비밀번호가 성공적으로 변경되었습니다."});
  @override
  List<Object?> get props => [successMessage];
}

class PasswordChangeFailure extends ProfileState {
  final String errorMessage;
  const PasswordChangeFailure(this.errorMessage);
  @override
  List<Object?> get props => [errorMessage];
}
