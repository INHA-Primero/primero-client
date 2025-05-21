// lib/features/onboarding/onboarding_screen.dart
import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart'; // 현재 이 파일에서는 Riverpod 직접 사용 안 함
import 'package:go_router/go_router.dart';
import 'package:primero/app/app_router.dart'; // AppRouteNames 사용
import 'package:primero/core/theme/app_colors.dart';
import 'package:primero/core/theme/app_text_style.dart';

// 각 온보딩 페이지의 데이터를 담을 클래스
class OnboardingPageData {
  final String assetPath; // 로컬 에셋 이미지 경로
  final String title;
  final String subtitle;
  final IconData? iconOnError; // 이미지 로드 실패 시 대체 아이콘
  final double imageHeightFactor; // 페이지별 이미지 높이 조절을 위한 팩터

  OnboardingPageData({
    required this.assetPath,
    required this.title,
    required this.subtitle,
    this.iconOnError,
    this.imageHeightFactor = 0.35, // 기본 이미지 높이 팩터
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

  // 온보딩 페이지 데이터 (assetPath에 실제 프로젝트 내 경로 지정)
  // pubspec.yaml 파일에 assets/images/ 폴더가 등록되어 있어야 합니다.
  final List<OnboardingPageData> _onboardingPages = [
    OnboardingPageData(
      assetPath: "assets/images/onboarding_1.png",
      title: "우리 손으로 아기나무를!",
      subtitle: "인하대학교에서 플라스틱 재활용을 통해\n나무를 가꿔보자!",
      iconOnError: Icons.eco_rounded,
      imageHeightFactor: 0.3, // 첫 번째 페이지만 이미지 크기를 약간 작게 (예: 화면 높이의 30%)
    ),
    OnboardingPageData(
      assetPath: "assets/images/onboarding_2.png",
      title: "바코드 스캔으로 시작해요!",
      subtitle: "바코드를 스캔해 인증을 완료하고\n플라스틱을 준비하세요!",
      iconOnError: Icons.qr_code_scanner_rounded,
      // imageHeightFactor: 0.35, // 기본값 사용
    ),
    OnboardingPageData(
      assetPath: "assets/images/onboarding_3.png",
      title: "AI가 플라스틱을 검사해요!",
      subtitle: "스캔을 통해 깨끗한 플라스틱을 인증받아\n포인트를 모아봐요!",
      iconOnError: Icons.smart_toy_rounded,
      // imageHeightFactor: 0.35, // 기본값 사용
    ),
    OnboardingPageData(
      assetPath: "assets/images/onboarding_4.png",
      title: "포인트로 아기나무에 물을 주세요!",
      subtitle: "모은 포인트로 물을 주고\n함께 아기나무를 키워봐요!",
      iconOnError: Icons.water_drop_rounded,
      // imageHeightFactor: 0.35, // 기본값 사용
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
                MediaQuery.of(context).size.height *
                pageData.imageHeightFactor, // 각 페이지별 높이 팩터 적용
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              print(
                "Error loading asset: ${pageData.assetPath}, Error: $error",
              );
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
                  onPressed: () {
                    // "시작하기" 버튼은 항상 회원가입 화면으로 이동
                    context.goNamed(AppRouteNames.signup);
                  },
                  child: Text(
                    '시작하기', // 버튼 텍스트 항상 "시작하기"
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
              onTap: () {
                // 로그인 화면으로 이동
                context.pushNamed(AppRouteNames.login);
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
