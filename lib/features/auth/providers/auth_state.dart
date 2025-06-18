// lib/features/auth/providers/auth_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  // 초기 상태
  const factory AuthState.initial() = _Initial;
  // 로딩 중 상태
  const factory AuthState.loading() = _Loading;
  // 최종 인증 완료 상태
  const factory AuthState.authenticated() = _Authenticated;
  // ✨ 비인증 상태 (파라미터 없음)
  const factory AuthState.unauthenticated() = _Unauthenticated;
  // 에러 발생 상태
  const factory AuthState.error(String message) = _Error;

  // 이메일 인증 코드 발송 성공 상태
  const factory AuthState.codeSentSuccess() = _CodeSentSuccess;

  // 이메일 코드 검증 성공 상태
  const factory AuthState.verificationSuccess() = _VerificationSuccess;
}
