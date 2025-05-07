// lib/routes/app_router.dart

import 'package:go_router/go_router.dart';
import 'package:primero/core/widgets/main_scaffold.dart';
import 'package:primero/features/onboarding/onboarding_screen.dart';
import 'package:primero/features/home/home_screen.dart';
import 'package:primero/features/scan/scan_screen.dart';
import 'package:primero/features/profile/profile_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const OnboardingScreen()),
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/scan', builder: (_, __) => const ScanScreen()),
        GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
      ],
    ),
  ],
);
