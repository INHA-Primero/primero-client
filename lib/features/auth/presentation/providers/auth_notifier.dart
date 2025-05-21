// lib/features/auth/presentation/providers/auth_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primero/core/services/device_uuid_service.dart';
import 'package:primero/features/auth/domain/entities/auth_response_entity.dart';
import 'package:primero/features/auth/domain/usecases/get_auth_status_usecase.dart';
import 'package:primero/features/auth/domain/usecases/login_usecase.dart';
import 'package:primero/features/auth/domain/usecases/logout_usecase.dart';
import 'package:primero/features/auth/domain/usecases/request_email_verification_usecase.dart';
import 'package:primero/features/auth/domain/usecases/resend_email_verification_usecase.dart';
import 'package:primero/features/auth/domain/usecases/signup_usecase.dart';
import 'package:primero/features/auth/domain/usecases/verify_email_usecase.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final SignupUseCase _signupUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetAuthStatusUseCase _getAuthStatusUseCase;
  final RequestEmailVerificationUseCase _requestEmailVerificationUseCase;
  final ResendEmailVerificationUseCase _resendEmailVerificationUseCase;
  final VerifyEmailUseCase _verifyEmailUseCase;
  final DeviceUuidService _deviceUuidService; // DeviceUuidService 주입

  AuthNotifier({
    required LoginUseCase loginUseCase,
    required SignupUseCase signupUseCase,
    required LogoutUseCase logoutUseCase,
    required GetAuthStatusUseCase getAuthStatusUseCase,
    required RequestEmailVerificationUseCase requestEmailVerificationUseCase,
    required ResendEmailVerificationUseCase resendEmailVerificationUseCase,
    required VerifyEmailUseCase verifyEmailUseCase,
    required DeviceUuidService deviceUuidService, // 생성자에서 주입
  }) : _loginUseCase = loginUseCase,
       _signupUseCase = signupUseCase,
       _logoutUseCase = logoutUseCase,
       _getAuthStatusUseCase = getAuthStatusUseCase,
       _requestEmailVerificationUseCase = requestEmailVerificationUseCase,
       _resendEmailVerificationUseCase = resendEmailVerificationUseCase,
       _verifyEmailUseCase = verifyEmailUseCase,
       _deviceUuidService = deviceUuidService, // 초기화
       super(AuthInitial()) {
    // 앱 시작 시 현재 인증 상태 확인
    checkAuthStatus();
  }

  /// 앱 시작 시 또는 필요할 때 현재 인증 상태를 확인합니다.
  Future<void> checkAuthStatus() async {
    state = AuthLoading(); // 상태 확인 중 로딩 상태
    try {
      final authUser = await _getAuthStatusUseCase();
      if (authUser != null &&
          authUser.accessToken != null &&
          authUser.accessToken!.isNotEmpty) {
        // 유효한 토큰(또는 사용자 정보)이 있다면 인증된 상태로 변경
        state = AuthAuthenticated(authUser: authUser);
      } else {
        state = AuthUnauthenticated();
      }
    } catch (e) {
      state = AuthFailure(message: "인증 상태 확인 실패: ${e.toString()}");
    }
  }

  /// 이메일 인증을 요청합니다.
  Future<void> requestEmailVerification(String email) async {
    state = AuthEmailVerificationLoading();
    try {
      await _requestEmailVerificationUseCase(email);
      state = AuthEmailVerificationSent(email: email);
    } catch (e) {
      state = AuthFailure(message: e.toString());
    }
  }

  /// 이메일 인증번호를 재전송합니다.
  Future<void> resendEmailVerification(String email) async {
    state = AuthEmailVerificationLoading(); // 재전송도 로딩 상태로 표시
    try {
      await _resendEmailVerificationUseCase(email);
      state = AuthEmailVerificationSent(email: email); // 성공 시 다시 발송 완료 상태
    } catch (e) {
      state = AuthFailure(message: e.toString());
    }
  }

  /// 입력된 인증번호를 확인합니다.
  Future<void> verifyEmailCode(String email, String code) async {
    state = AuthEmailVerificationConfirmLoading(email: email);
    try {
      await _verifyEmailUseCase(email: email, verificationCode: code);
      state = AuthEmailVerified(email: email); // 인증 성공 상태
    } catch (e) {
      state = AuthFailure(message: e.toString());
    }
  }

  /// 회원가입을 시도합니다.
  Future<void> signup({
    required String email,
    required String password,
    required String name,
    required String studentNumber,
    required String nickname,
  }) async {
    state = AuthLoading();
    try {
      // deviceUuid는 SignupUseCase 내부에서 AuthRepository를 통해 가져옵니다.
      final authUser = await _signupUseCase(
        email: email,
        password: password,
        name: name,
        studentNumber: studentNumber,
        nickname: nickname,
      );
      state = AuthAuthenticated(authUser: authUser);
    } catch (e) {
      state = AuthFailure(message: e.toString());
    }
  }

  /// 로그인을 시도합니다.
  Future<void> login(String email, String password) async {
    state = AuthLoading();
    try {
      // deviceUuid는 LoginUseCase 내부에서 AuthRepository를 통해 가져옵니다.
      final authUser = await _loginUseCase(email: email, password: password);
      state = AuthAuthenticated(authUser: authUser);
    } catch (e) {
      state = AuthFailure(message: e.toString());
    }
  }

  /// 로그아웃을 수행합니다.
  Future<void> logout() async {
    state = AuthLoading(); // 로그아웃 진행 중
    try {
      await _logoutUseCase();
      state = AuthUnauthenticated(); // 로그아웃 성공 시 비인증 상태로 변경
    } catch (e) {
      // 로그아웃 실패 시에도 일단 클라이언트에서는 비인증 상태로 처리하는 것이 일반적
      state = AuthUnauthenticated();
      print("Logout error: ${e.toString()}"); // 로그아웃 실패는 로깅만 할 수도 있음
    }
  }

  /// 현재 저장된 device_uuid를 가져옵니다. (UI에서 직접 호출할 일은 적음)
  Future<String?> getDeviceUuid() async {
    return await _deviceUuidService.getOrCreateDeviceUuid();
  }
}
