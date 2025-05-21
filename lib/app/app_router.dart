// lib/app/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ConsumerWidget, WidgetRef 사용
import 'package:go_router/go_router.dart';
import 'package:primero/core/widgets/main_scaffold.dart';
import 'package:primero/features/auth/presentation/providers/auth_di.dart'; // authNotifierProvider
import 'package:primero/features/auth/presentation/providers/auth_state.dart'; // AuthState
import 'package:primero/features/auth/presentation/screens/login_screen.dart'; // LoginScreen
import 'package:primero/features/auth/presentation/screens/signup_screen.dart'; // SignupScreen
import 'package:primero/features/onboarding/onboarding_screen.dart';
import 'package:primero/features/home/home_screen.dart';
import 'package:primero/features/scan/scan_screen.dart';
import 'package:primero/features/profile/presentation/screens/profile_screen.dart';
import 'package:primero/features/profile/presentation/screens/profile_edit_screen.dart';
import 'package:primero/features/profile/presentation/screens/password_change_screen.dart';
import 'package:primero/features/profile/domain/entities/user_profile_entity.dart';

class AppRoutePaths {
  static const String onboarding = '/';
  static const String login = '/login'; // 로그인 경로 추가
  static const String signup = '/signup'; // 회원가입 경로 추가
  // static const String emailVerification = '/email-verify'; // 필요시 별도 이메일 인증 화면 경로

  static const String home = '/home';
  static const String scan = '/scan';
  static const String profile = '/profile';
  static const String profileEditSubPath = 'edit';
  static const String passwordChangeSubPath = 'change-password';
}

class AppRouteNames {
  static const String onboarding = 'onboarding';
  static const String login = 'login'; // 로그인 이름 추가
  static const String signup = 'signup'; // 회원가입 이름 추가
  // static const String emailVerification = 'emailVerification';

  static const String home = 'home';
  static const String scan = 'scan';
  static const String profile = 'profile';
  static const String profileEdit = 'profileEdit';
  static const String passwordChange = 'passwordChange';
}

// GoRouter 인스턴스를 Provider로 제공하여 앱 전체에서 접근 가능하게 합니다.
// redirect 로직에서 AuthNotifier 상태를 읽기 위해 ConsumerStatefulWidget 또는 HookConsumerWidget을 사용할 수 없으므로,
// redirect 콜백 내에서 ProviderContainer를 직접 사용하거나,
// 앱의 루트 위젯(MyApp)을 ConsumerWidget으로 만들고 거기서 라우터 설정을 하도록 변경할 수 있습니다.
// 여기서는 앱 재시작 시 또는 AuthNotifier 상태 변경 시 redirect가 다시 평가되도록 하는 일반적인 접근 방식을 따릅니다.
// 실제로는 AuthNotifier의 상태를 listen하여 라우팅을 동적으로 변경하는 것이 더 복잡할 수 있으므로,
// GoRouter의 refreshListenable 기능을 활용하는 것이 좋습니다.

final goRouterProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authNotifierProvider.notifier);

  // AuthNotifier의 상태 변화를 감지하여 GoRouter를 다시 빌드(redirect 로직 재실행)하도록 함
  // ValueNotifier를 사용하여 AuthNotifier의 상태 변경을 GoRouter에 알림
  final refreshNotifier = ValueNotifier<int>(0);
  ref.listen<AuthState>(authNotifierProvider, (_, next) {
    refreshNotifier.value++; // 상태 변경 시 notifier 값 변경하여 GoRouter 재평가 유도
  });

  return GoRouter(
    initialLocation: AppRoutePaths.onboarding,
    debugLogDiagnostics: true,
    refreshListenable: refreshNotifier, // AuthState 변경 시 redirect 로직 재실행
    redirect: (BuildContext context, GoRouterState state) {
      final authState = ref.read(
        authNotifierProvider,
      ); // redirect에서는 ref.read 사용

      final isLoggedIn = authState is AuthAuthenticated;
      final isLoggingIn = state.matchedLocation == AppRoutePaths.login;
      final isSigningUp = state.matchedLocation == AppRoutePaths.signup;
      final isOnboarding = state.matchedLocation == AppRoutePaths.onboarding;

      print(
        'Current Route: ${state.matchedLocation}, AuthState: $authState, IsLoggedIn: $isLoggedIn',
      );

      if (!isLoggedIn && !isLoggingIn && !isSigningUp && !isOnboarding) {
        // 로그인 안된 상태에서 로그인/회원가입/온보딩 화면이 아니면 온보딩으로 보냄
        // (또는 로그인 화면으로 바로 보내도 됨)
        print(
          'Redirecting to onboarding because not logged in and not on auth pages.',
        );
        return AppRoutePaths.onboarding;
      }

      if (isLoggedIn && (isLoggingIn || isSigningUp || isOnboarding)) {
        // 로그인 된 상태에서 로그인/회원가입/온보딩 화면으로 가려고 하면 홈으로 보냄
        print(
          'Redirecting to home because logged in and on auth/onboarding page.',
        );
        return AppRoutePaths.home;
      }

      // 그 외의 경우는 현재 경로 유지
      print('No redirection needed.');
      return null;
    },
    routes: [
      GoRoute(
        name: AppRouteNames.onboarding,
        path: AppRoutePaths.onboarding,
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        name: AppRouteNames.login, // 로그인 화면 라우트 추가
        path: AppRoutePaths.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        name: AppRouteNames.signup, // 회원가입 화면 라우트 추가
        path: AppRoutePaths.signup,
        builder: (_, __) => const SignupScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          // MainScaffold를 ConsumerWidget으로 만들거나, 여기서 ref를 전달받아 사용할 수 있습니다.
          // 현재 MainScaffold는 StatefulWidget이므로, BottomNavBar의 현재 인덱스를
          // GoRouter의 상태로부터 계산해야 합니다.
          // 예: final location = GoRouter.of(context).location;
          //     int selectedIndex = _calculateSelectedIndex(location);
          return MainScaffold(child: child);
        },
        routes: [
          GoRoute(
            name: AppRouteNames.home,
            path: AppRoutePaths.home,
            builder: (_, __) => const HomeScreen(),
          ),
          GoRoute(
            name: AppRouteNames.scan,
            path: AppRoutePaths.scan,
            builder: (_, __) => const ScanScreen(),
          ),
          GoRoute(
            name: AppRouteNames.profile,
            path: AppRoutePaths.profile,
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                name: AppRouteNames.profileEdit,
                path: AppRoutePaths.profileEditSubPath,
                builder: (context, state) {
                  final userProfile = state.extra as UserProfileEntity?;
                  if (userProfile != null) {
                    return ProfileEditScreen(initialProfile: userProfile);
                  }
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (context.mounted) context.goNamed(AppRouteNames.profile);
                  });
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                },
                routes: [
                  GoRoute(
                    name: AppRouteNames.passwordChange,
                    path: AppRoutePaths.passwordChangeSubPath,
                    builder: (_, __) => const PasswordChangeScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
