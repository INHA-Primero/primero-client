// lib/features/auth/domain/repositories/auth_repository.dart
import 'package:primero/features/auth/data/models/email_verification_confirm_request_model.dart';
import 'package:primero/features/auth/data/models/email_verification_request_model.dart';
import 'package:primero/features/auth/data/models/login_request_model.dart';
import 'package:primero/features/auth/data/models/signup_request_model.dart';
import 'package:primero/features/auth/domain/entities/auth_response_entity.dart';

abstract class AuthRepository {
  // 이메일 인증 요청
  Future<void> requestEmailVerification(
    EmailVerificationRequestModel requestModel,
  );
  // 이메일 인증번호 재전송
  Future<void> resendEmailVerification(
    EmailVerificationRequestModel requestModel,
  );
  // 이메일 인증번호 확인
  Future<void> verifyEmailCode(
    EmailVerificationConfirmRequestModel requestModel,
  );
  // 회원가입
  Future<AuthResponseEntity> signup(SignupRequestModel requestModel);
  // 로그인
  Future<AuthResponseEntity> login(LoginRequestModel requestModel);
  // 로그아웃
  Future<void> logout();
  // 현재 인증 상태(토큰 유효성 등) 확인 및 사용자 정보 가져오기
  Future<AuthResponseEntity?> getAuthStatus();
  // 저장된 Device UUID 가져오기
  Future<String?> getDeviceUuid();
}
