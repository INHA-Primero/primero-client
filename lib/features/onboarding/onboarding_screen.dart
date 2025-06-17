// lib/features/onboarding/onboarding_screen.dart
// 기존 UI는 100% 유지하고, 네비게이션 코드만 수정했습니다.

import 'package:flutter/material.dart';
// go_router와 AppRouteNames import를 제거하고, 이동할 화면을 직접 import 합니다.
import 'package:primero/core/theme/app_colors.dart';
import 'package:primero/core/theme/app_text_style.dart';
import 'package:primero/features/auth/ui/screens/login_screen.dart';
import 'package:primero/features/auth/ui/screens/signup_screen.dart'; // 사용자님의 원래 회원가입 화면

// 각 온보딩 페이지의 데이터를 담을 클래스
class OnboardingPageData {
  final String assetPath;
  final String title;
  final String subtitle;
  final IconData? iconOnError;
  final double imageHeightFactor;

  OnboardingPageData({
    required this.assetPath,
    required this.title,
    required this.subtitle,
    this.iconOnError,
    this.imageHeightFactor = 0.35,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPageData> _onboardingPages = [
    OnboardingPageData(
      assetPath: "assets/images/onboarding_1.png",
      title: "우리 손으로 아기나무를!",
      subtitle: "인하대학교에서 플라스틱 재활용을 통해\n나무를 가꿔보자!",
      iconOnError: Icons.eco_rounded,
      imageHeightFactor: 0.3,
    ),
    OnboardingPageData(
      assetPath: "assets/images/onboarding_2.png",
      title: "바코드 스캔으로 시작해요!",
      subtitle: "바코드를 스캔해 인증을 완료하고\n플라스틱을 준비하세요!",
      iconOnError: Icons.qr_code_scanner_rounded,
    ),
    OnboardingPageData(
      assetPath: "assets/images/onboarding_3.png",
      title: "AI가 플라스틱을 검사해요!",
      subtitle: "스캔을 통해 깨끗한 플라스틱을 인증받아\n포인트를 모아봐요!",
      iconOnError: Icons.smart_toy_rounded,
    ),
    OnboardingPageData(
      assetPath: "assets/images/onboarding_4.png",
      title: "포인트로 아기나무에 물을 주세요!",
      subtitle: "모은 포인트로 물을 주고\n함께 아기나무를 키워봐요!",
      iconOnError: Icons.water_drop_rounded,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _navigateToNextPage() {
    if (_currentPage < _onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _navigateToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildPageContent(BuildContext context, OnboardingPageData pageData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            pageData.assetPath,
            height:
                MediaQuery.of(context).size.height * pageData.imageHeightFactor,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                pageData.iconOnError ?? Icons.image_not_supported_rounded,
                size: 100,
                color: Colors.grey[400],
              );
            },
          ),
          const SizedBox(height: 48),
          Text(
            pageData.title,
            textAlign: TextAlign.center,
            style: AppTextStyle.bold.copyWith(
              fontSize: 22,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            pageData.subtitle,
            textAlign: TextAlign.center,
            style: AppTextStyle.regular.copyWith(
              fontSize: 15,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_onboardingPages.length, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          height: 8,
          width: _currentPage == index ? 24 : 8,
          decoration: BoxDecoration(
            color: _currentPage == index ? AppColors.primary : Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: _onboardingPages.length,
                    onPageChanged: _onPageChanged,
                    itemBuilder: (context, index) {
                      return _buildPageContent(
                        context,
                        _onboardingPages[index],
                      );
                    },
                  ),
                  if (_currentPage > 0)
                    Positioned(
                      left: 16,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.black,
                        ),
                        onPressed: _navigateToPreviousPage,
                        tooltip: '이전',
                      ),
                    ),
                  if (_currentPage < _onboardingPages.length - 1)
                    Positioned(
                      right: 16,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.black,
                        ),
                        onPressed: _navigateToNextPage,
                        tooltip: '다음',
                      ),
                    ),
                ],
              ),
            ),
            _buildPageIndicator(),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  // [수정된 부분 1]
                  onPressed: () {
                    // 사용자님의 원래 회원가입 화면으로 이동합니다.
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    );
                  },
                  child: Text(
                    '시작하기',
                    style: AppTextStyle.semiBold.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              // [수정된 부분 2]
              onTap: () {
                // 로그인 화면으로 이동합니다.
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '이미 계정이 있나요? ',
                      style: AppTextStyle.regular.copyWith(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '로그인',
                      style: AppTextStyle.semiBold.copyWith(
                        color: AppColors.primary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
