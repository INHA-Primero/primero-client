// lib/features/auth/domain/repositories/auth_repository.dart
import 'package:primero/features/auth/data/models/email_verification_confirm_request_model.dart';
import 'package:primero/features/auth/data/models/email_verification_request_model.dart';
import 'package:primero/features/auth/data/models/login_request_model.dart';
import 'package:primero/features/auth/data/models/signup_request_model.dart';
import 'package:primero/features/auth/domain/entities/auth_response_entity.dart';

abstract class AuthRepository {
  Future<void> requestEmailVerification(
    EmailVerificationRequestModel requestModel,
  );
  Future<void> resendEmailVerification(
    EmailVerificationRequestModel requestModel,
  );
  Future<void> verifyEmailCode(
    EmailVerificationConfirmRequestModel requestModel,
  );

  // signup 메서드 시그니처: deviceUuid를 별도 파라미터로 받도록 변경
  Future<AuthResponseEntity> signup(
    SignupRequestModel requestModel,
    String deviceUuid,
  );

  // login 메서드 시그니처: deviceUuid를 별도 파라미터로 받도록 변경
  Future<AuthResponseEntity> login(
    LoginRequestModel requestModel,
    String deviceUuid,
  );

  Future<void> logout();
  Future<AuthResponseEntity?> getAuthStatus();
  Future<String?>
  getDeviceUuid(); // DeviceUuidService를 통해 제공될 것이므로 중복될 수 있음. 필요시 유지.
}
