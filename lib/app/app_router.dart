// lib/routes/app_router.dart

import 'package:go_router/go_router.dart';
import 'package:primero/core/widgets/main_scaffold.dart';
import 'package:primero/features/onboarding/onboarding_screen.dart';
import 'package:primero/features/home/home_screen.dart';
import 'package:primero/features/scan/scan_screen.dart';
// lib/routes/app_router.dart (사용자님이 제공해주신 파일 경로)

import 'package:flutter/material.dart'; // WidgetsBinding, Scaffold 등을 위해 필요

// 프로필 관련 화면 및 엔티티 임포트 추가
import 'package:primero/features/profile/presentation/screens/profile_screen.dart';
import 'package:primero/features/profile/presentation/screens/profile_edit_screen.dart';
import 'package:primero/features/profile/presentation/screens/password_change_screen.dart';
import 'package:primero/features/profile/domain/entities/user_profile_entity.dart';

/// 앱 내에서 사용될 경로 문자열들을 상수로 관리합니다.
class AppRoutePaths {
  // 기존 경로들은 그대로 유지 (사용자 코드에 명시된 경로 사용)
  static const String onboarding = '/'; // 사용자 코드의 initialLocation과 일치
  static const String home = '/home';
  static const String scan = '/scan';
  static const String profile = '/profile';

  // 프로필 기능 확장을 위한 하위 경로
  static const String profileEditSubPath = 'edit'; // '/profile'에 대한 상대 경로
  static const String passwordChangeSubPath =
      'change-password'; // '/profile/edit'에 대한 상대 경로
}

/// 앱 내에서 사용될 경로 이름들을 상수로 관리합니다.
class AppRouteNames {
  // 기존 경로들에 대한 이름 (선택적으로 추가 가능, 사용자 코드에는 없었으므로 최소한으로 추가)
  static const String onboarding = 'onboarding';
  static const String home = 'home';
  static const String scan = 'scan';
  static const String profile = 'profile';

  // 프로필 기능 확장을 위한 경로 이름
  static const String profileEdit = 'profileEdit';
  static const String passwordChange = 'passwordChange';
}

final appRouter = GoRouter(
  initialLocation: AppRoutePaths.onboarding, // 사용자 코드와 동일하게 '/'
  debugLogDiagnostics: true, // 개발 중 라우팅 로그 확인에 유용
  routes: [
    GoRoute(
      name: AppRouteNames.onboarding, // 이름 부여 (선택적)
      path: AppRoutePaths.onboarding, // 사용자 코드와 동일하게 '/'
      builder: (_, __) => const OnboardingScreen(),
    ),
    // 로그인 경로는 사용자님의 원본 코드에 없었으므로, 필요하다면 여기에 추가합니다.
    // GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          name: AppRouteNames.home, // 이름 부여 (선택적)
          path: AppRoutePaths.home, // 사용자 코드와 동일하게 '/home'
          builder: (_, __) => const HomeScreen(),
        ),
        GoRoute(
          name: AppRouteNames.scan, // 이름 부여 (선택적)
          path: AppRoutePaths.scan, // 사용자 코드와 동일하게 '/scan'
          builder: (_, __) => const ScanScreen(),
        ),
        GoRoute(
          name: AppRouteNames.profile, // 사용자 코드의 'profile' 이름 유지 또는 이 이름 사용
          path: AppRoutePaths.profile, // 사용자 코드와 동일하게 '/profile'
          builder: (context, state) => const ProfileScreen(),
          routes: [
            // ProfileScreen의 하위 경로로 ProfileEditScreen 정의
            GoRoute(
              name:
                  AppRouteNames
                      .profileEdit, // 사용자 코드의 'profileEdit' 이름 유지 또는 이 이름 사용
              path:
                  AppRoutePaths
                      .profileEditSubPath, // 'edit' -> 최종 경로는 /profile/edit
              builder: (context, state) {
                final userProfile = state.extra as UserProfileEntity?;
                if (userProfile != null) {
                  return ProfileEditScreen(initialProfile: userProfile);
                }
                // extra로 UserProfileEntity가 전달되지 않은 경우, ProfileScreen으로 리다이렉트합니다.
                print(
                  "Error: UserProfileEntity not passed to ProfileEditScreen. Redirecting to profile.",
                );
                // 빌드 완료 후 안전하게 리다이렉트
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) {
                    context.goNamed(AppRouteNames.profile);
                  }
                });
                // 리다이렉트 전까지 보여줄 임시 로딩 화면 또는 빈 화면
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              },
              routes: [
                // ProfileEditScreen의 하위 경로로 PasswordChangeScreen 정의
                GoRoute(
                  name: AppRouteNames.passwordChange,
                  path:
                      AppRoutePaths
                          .passwordChangeSubPath, // 'change-password' -> 최종 /profile/edit/change-password
                  builder: (BuildContext context, GoRouterState state) {
                    return const PasswordChangeScreen();
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
