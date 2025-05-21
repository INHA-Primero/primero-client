// lib/features/auth/presentation/providers/auth_state.dart
import 'package:equatable/equatable.dart';
import 'package:primero/features/auth/domain/entities/auth_response_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// 초기 상태 또는 로그아웃된 상태
class AuthInitial extends AuthState {}

/// 인증 과정(로그인, 회원가입, 이메일 인증 등) 진행 중인 상태
class AuthLoading extends AuthState {}

/// 이메일 인증번호 발송 요청 중
class AuthEmailVerificationLoading extends AuthState {}

/// 이메일 인증번호가 성공적으로 발송된 상태
class AuthEmailVerificationSent extends AuthState {
  final String email; // 어떤 이메일로 발송되었는지 정보 포함
  const AuthEmailVerificationSent({required this.email});
  @override
  List<Object?> get props => [email];
}

/// 이메일 인증번호 확인/검증 중
class AuthEmailVerificationConfirmLoading extends AuthState {
  final String email;
  const AuthEmailVerificationConfirmLoading({required this.email});
  @override
  List<Object?> get props => [email];
}

/// 이메일 인증이 성공적으로 완료된 상태
class AuthEmailVerified extends AuthState {
  final String email; // 인증된 이메일 정보
  const AuthEmailVerified({required this.email});
  @override
  List<Object?> get props => [email];
}

/// 사용자가 성공적으로 인증된 상태 (로그인 또는 회원가입 성공)
class AuthAuthenticated extends AuthState {
  final AuthResponseEntity authUser; // 인증된 사용자 정보 및 토큰
  const AuthAuthenticated({required this.authUser});

  @override
  List<Object?> get props => [authUser];
}

/// 사용자가 인증되지 않은 상태 (예: 토큰 없음, 로그아웃 상태)
class AuthUnauthenticated extends AuthState {}

/// 인증 과정 중 오류가 발생한 상태
class AuthFailure extends AuthState {
  final String message;
  const AuthFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
