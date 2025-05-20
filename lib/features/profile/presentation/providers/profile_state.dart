// lib/features/profile/presentation/providers/profile_state.dart
import 'package:equatable/equatable.dart';
import 'package:primero/features/profile/domain/entities/user_profile_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

// 프로필 정보 로드 성공, 또는 닉네임/이미지 업데이트 성공 시 이 상태 사용
class ProfileLoaded extends ProfileState {
  final UserProfileEntity userProfile;
  const ProfileLoaded(this.userProfile);
  @override
  List<Object?> get props => [userProfile];
}

// 프로필 정보 로드/업데이트 시 일반 오류
class ProfileError extends ProfileState {
  final String message;
  final UserProfileEntity? previousProfile; // 오류 시 이전 데이터 유지 옵션
  const ProfileError(this.message, {this.previousProfile});
  @override
  List<Object?> get props => [message, previousProfile];
}

// 닉네임/이미지 정보 업데이트 중
class ProfileInfoUpdating extends ProfileLoaded {
  // 기존 정보 표시 위해 ProfileLoaded 상속
  const ProfileInfoUpdating(super.userProfile);
}

// 닉네임/이미지 정보 업데이트 성공 (명시적 피드백용)
class ProfileInfoUpdateSuccess extends ProfileLoaded {
  final String successMessage;
  const ProfileInfoUpdateSuccess(
    super.userProfile, {
    this.successMessage = "프로필 정보가 업데이트되었습니다.",
  });
  @override
  List<Object?> get props => [userProfile, successMessage];
}

// 닉네임/이미지 정보 업데이트 실패
class ProfileInfoUpdateFailure extends ProfileLoaded {
  final String errorMessage;
  const ProfileInfoUpdateFailure(super.userProfile, this.errorMessage);
  @override
  List<Object?> get props => [userProfile, errorMessage];
}

// 비밀번호 변경 관련 상태
class PasswordChangeInitial extends ProfileState {}

class PasswordChangeLoading extends ProfileState {}

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
