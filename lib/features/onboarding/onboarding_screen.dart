import 'package:flutter/material.dart';
import 'package:primero/core/theme/app_colors.dart';
import 'package:primero/core/theme/app_text_style.dart';
import 'package:go_router/go_router.dart';

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
            children: [
              const SizedBox(height: 140),

              // 1) 중앙 이미지
              Image.asset(
                'assets/images/babyTree2.png',
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
              const SizedBox(height: 88),

              // 4) 시작하기 버튼
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {
                    context.go('/home');
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
                    onTap: () => context.go('/login'),
                    child: Text(
                      '로그인',
                      style: AppTextStyle.medium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
