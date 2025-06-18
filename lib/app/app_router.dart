// lib/app/app_router.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primero/core/widgets/main_scaffold.dart';
import 'package:primero/features/auth/providers/auth_di.dart';
import 'package:primero/features/auth/providers/auth_state.dart';
import 'package:primero/features/auth/ui/screens/login_screen.dart';
import 'package:primero/features/onboarding/onboarding_screen.dart';

class AppRouter extends ConsumerWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // SharedPreferences가 준비될 때까지 기다립니다.
    final sharedPrefsAsyncValue = ref.watch(sharedPreferencesProvider);
    // 현재 인증 상태를 감시합니다.
    final authState = ref.watch(authNotifierProvider);

    // SharedPreferences 로딩 상태에 따라 UI를 분기합니다.
    return sharedPrefsAsyncValue.when(
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error:
          (err, stack) => const Scaffold(body: Center(child: Text('앱 초기화 오류'))),

      // SharedPreferences가 준비되면, 인증 상태에 따라 최종 화면을 결정합니다.
      data: (_) {
        return authState.when(
          initial:
              () => const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
          loading:
              () => const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),

          // ✨ [수정] 인증 성공 -> 메인 화면 (하단 탭 바 포함)
          authenticated: () => const MainScaffold(),

          // ✨ [수정] 나머지 모든 상태는 Onboarding/Login 화면으로 연결됩니다.
          // unauthenticated 상태는 더 이상 파라미터를 받지 않습니다.
          unauthenticated: () => const OnboardingOrLoginScreen(),
          codeSentSuccess: () => const OnboardingOrLoginScreen(),
          verificationSuccess: () => const OnboardingOrLoginScreen(),
          error: (_) => const OnboardingOrLoginScreen(),
        );
      },
    );
  }
}

// 이 위젯은 변경사항 없습니다.
class OnboardingOrLoginScreen extends StatelessWidget {
  const OnboardingOrLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: 사용자가 온보딩을 봤는지 여부를 SharedPreferences 등으로 관리하면 더 좋습니다.
    const bool hasSeenOnboarding = false;
    return hasSeenOnboarding ? const LoginScreen() : const OnboardingScreen();
  }
}
