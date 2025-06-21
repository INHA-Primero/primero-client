import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primero/features/profile/repositories/profile_repository.dart';
import '../models/login_request_model.dart';
import '../models/signup_request_model.dart';
import '../repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final ProfileRepository _profileRepository;

  AuthNotifier(this._authRepository, this._profileRepository)
    : super(const AuthState.initial()) {
    checkAuthStatus();
  }

  // 앱 시작 시 토큰 유효성 검사
  Future<void> checkAuthStatus() async {
    state = const AuthState.loading();
    try {
      final hasToken = await _authRepository.getAuthStatus();
      if (hasToken) {
        // 토큰이 존재하면, 프로필 조회를 통해 유효성을 최종 검증합니다.
        // 이 호출이 실패하면 catch 블록으로 이동하여 로그아웃 처리됩니다.
        await _profileRepository.getUserProfile();
        state = const AuthState.authenticated();
      } else {
        // 토큰이 없으면 비인증 상태입니다.
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      // checkAuthStatus 중 발생하는 모든 오류는 토큰이 유효하지 않다는 의미입니다.
      // 안전하게 로컬 토큰을 삭제하고 비인증 상태로 전환합니다.
      await _authRepository.logout();
      state = const AuthState.unauthenticated();
    }
  }

  // 로그인 로직 수정
  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    try {
      final request = LoginRequestModel(email: email, password: password);
      // 1. 로그인 API 호출 및 새 토큰 저장
      await _authRepository.login(request);

      // 2. ✨ [핵심 수정] 불필요한 checkAuthStatus 재호출 제거
      // 로그인 API가 성공했다는 것은 토큰이 유효하다는 의미입니다.
      // 즉시 인증된 상태로 전환합니다.
      state = const AuthState.authenticated();
    } catch (e) {
      // 로그인 실패 시 에러 상태로 전환하여 UI에 피드백을 줍니다.
      state = AuthState.error(e.toString());
    }
  }

  // 회원가입 로직 (수정된 login을 호출하므로 자동으로 안정화됩니다.)
  Future<void> signup({
    required String name,
    required int studentNumber,
    required String treeName,
    required String email,
    required String password,
    required String confirmPassword,
    required String deviceUuid,
  }) async {
    state = const AuthState.loading();
    try {
      final request = SignupRequestModel(
        name: name,
        studentNumber: studentNumber,
        treeName: treeName,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        deviceUuid: deviceUuid,
      );
      await _authRepository.signup(request);
      // 회원가입 성공 후, 수정된 로그인 로직을 호출합니다.
      await login(email, password);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> sendVerificationCode(String email) async {
    state = const AuthState.loading();
    try {
      await _authRepository.sendVerificationCode(email);
      state = const AuthState.codeSentSuccess();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> verifyCode({required String email, required String code}) async {
    state = const AuthState.loading();
    try {
      await _authRepository.verifyCode(email: email, code: code);
      state = const AuthState.verificationSuccess();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> logout() async {
    state = const AuthState.loading();
    try {
      await _authRepository.logout();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }
}
