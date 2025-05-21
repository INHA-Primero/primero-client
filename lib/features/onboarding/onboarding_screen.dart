// lib/features/onboarding/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:primero/core/theme/app_colors.dart';
import 'package:primero/core/theme/app_text_style.dart';
import 'package:go_router/go_router.dart';
import 'package:primero/app/app_router.dart'; // AppRouteNames 사용을 위해 추가

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬보다는 상단 여백으로 조절
            children: [
              const SizedBox(height: 140), // 상단 여백
              // 1) 중앙 이미지
              Image.asset(
                'assets/images/babyTree2.png', // 이미지 경로는 프로젝트에 맞게 확인해주세요.
                width: 234,
                height: 234,
              ),

              const SizedBox(height: 56),

              // 2) 타이틀
              Text(
                '우리 손으로 아기나무를!',
                textAlign: TextAlign.center,
                style: AppTextStyle.bold.copyWith(fontSize: 24),
              ),
              const SizedBox(height: 4),

              // 3) 서브타이틀
              Text(
                '인하대학교에서 플라스틱 재활용을 통해\n나무를 가꿔보자!',
                textAlign: TextAlign.center,
                style: AppTextStyle.medium.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 88), // 버튼과의 간격
              // 4) 시작하기 버튼
              SizedBox(
                width: double.infinity, // 버튼 너비 최대로
                height: 48, // 버튼 높이
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, // 주요 색상 사용
                    shape: const StadiumBorder(), // 둥근 모서리 버튼
                  ),
                  onPressed: () {
                    // "시작하기" 버튼 클릭 시 회원가입 화면으로 이동
                    // context.go('/home'); // 기존: 홈으로 이동
                    context.goNamed(AppRouteNames.signup); // 변경: 회원가입 화면으로 이동
                  },
                  child: Text(
                    '시작하기',
                    style: AppTextStyle.medium.copyWith(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // 5) 로그인 링크
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '이미 계정이 있나요? ',
                    style: AppTextStyle.regular.copyWith(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () {
                      // "로그인" 텍스트 클릭 시 로그인 화면으로 이동
                      context.pushNamed(
                        AppRouteNames.login,
                      ); // pushNamed 또는 goNamed 사용
                    },
                    child: Text(
                      '로그인',
                      style: AppTextStyle.medium.copyWith(
                        color: AppColors.primary,
                        // fontWeight: FontWeight.bold, // 좀 더 강조하고 싶다면
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(), // 하단 공간 확보 (필요시)
            ],
          ),
        ),
      ),
    );
  }
}
