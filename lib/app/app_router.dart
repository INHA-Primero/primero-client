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
    final authState = ref.watch(authNotifierProvider);

    return authState.when(
      initial:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),

      authenticated: () => const MainScaffold(),
      unauthenticated: () => const OnboardingOrLoginScreen(),
      codeSentSuccess: () => const OnboardingOrLoginScreen(),
      verificationSuccess: () => const OnboardingOrLoginScreen(),
      error: (_) => const OnboardingOrLoginScreen(),
    );
  }
}

class OnboardingOrLoginScreen extends StatelessWidget {
  const OnboardingOrLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const bool hasSeenOnboarding = false;
    return hasSeenOnboarding ? const LoginScreen() : const OnboardingScreen();
  }
}
