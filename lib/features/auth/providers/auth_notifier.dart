// lib/features/auth/providers/auth_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../profile/repositories/profile_repository.dart';
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

  Future<void> checkAuthStatus() async {
    state = const AuthState.loading();
    try {
      final hasToken = await _authRepository.getAuthStatus();
      if (hasToken) {
        // 토큰이 유효한지 프로필 조회를 통해 최종 확인
        await _profileRepository.getUserProfile();
        state = const AuthState.authenticated();
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      // checkAuthStatus 실패는 토큰이 없거나 유효하지 않다는 의미
      await _authRepository.logout();
      state = const AuthState.unauthenticated();
    }
  }

  // ✨ [수정된 login 메서드]
  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    try {
      final request = LoginRequestModel(email: email, password: password);
      await _authRepository.login(request);

      // 로그인 성공 후, 저장된 토큰으로 상태를 최종 검증
      await checkAuthStatus();
    } catch (e) {
      // 로그인 API 또는 checkAuthStatus 실패 시 에러 상태로 전환
      state = AuthState.error(e.toString());
      // unauthenticated 상태로 되돌려 다시 로그인 유도
      Future.delayed(const Duration(milliseconds: 100), () {
        state = const AuthState.unauthenticated();
      });
    }
  }

  // signup 메서드는 수정된 login을 호출하므로 자동으로 해결됩니다.
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
      await login(email, password);
    } catch (e) {
      state = AuthState.error(e.toString());
      Future.delayed(const Duration(milliseconds: 100), () {
        state = const AuthState.unauthenticated();
      });
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
