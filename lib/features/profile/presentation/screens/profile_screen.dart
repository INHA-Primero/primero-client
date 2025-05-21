// lib/features/profile/presentation/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primero/core/theme/app_colors.dart';
import 'package:primero/core/theme/app_text_style.dart';
import 'package:primero/features/profile/domain/entities/user_profile_entity.dart';
import 'package:primero/features/profile/presentation/providers/profile_di.dart';
import 'package:primero/features/profile/presentation/providers/profile_state.dart';
import 'package:go_router/go_router.dart';
import 'package:primero/app/app_router.dart'; // AppRouteNames 사용

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  // 기본 프로필 이미지 경로 (assets 폴더에 해당 파일이 있어야 함)
  // 사용자님이 제공해주신 코드의 경로를 사용합니다.
  static const String defaultProfileAssetPath =
      'assets/images/defaultProfileImage.png';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileNotifierProvider);
    final profileNotifier = ref.read(profileNotifierProvider.notifier);

    const Color cardAndDividerColor = Color(0xFFF3F4F5); // 히스토리 카드 및 구분선 색상
    // 프로필 카드 내 텍스트 색상은 AppTextStyle의 기본값을 따르거나,
    // 피그마 디자인에 더 가깝게 하려면 여기서 명시적으로 정의할 수 있습니다.
    // 예: const Color profileNameColor = Colors.black87;
    // 예: const Color profileSubTextColor = Colors.black54;

    void showMenuComingSoonSnackBar() {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('메뉴 기능 구현 예정입니다.')));
    }

    void navigateToEditScreen(UserProfileEntity profile) {
      context.pushNamed(AppRouteNames.profileEdit, extra: profile);
    }

    return Scaffold(
      backgroundColor: Colors.white, // 전체 화면 배경 흰색
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          // 1. AppBar 타이틀
          '나의 프로필',
          style: AppTextStyle.bold.copyWith(
            fontSize: 22,
            color: Colors.black87,
          ),
        ),
        centerTitle: false,
        titleSpacing: 20.0, // 1. 원하는 왼쪽 여백 설정
        toolbarHeight: 70.0, // AppBar 높이
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: const Icon(
                Icons.menu_rounded,
                color: Colors.black,
                size: 28,
              ), // 아이콘 색상 및 크기
              onPressed: showMenuComingSoonSnackBar,
              tooltip: '메뉴',
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await profileNotifier.loadUserProfile();
        },
        color: AppColors.primary,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ), // ListView 전체에 좌우 패딩
          children: <Widget>[
            if (profileState is ProfileInitial ||
                (profileState is ProfileLoading &&
                    !(profileState is ProfileFullUpdating ||
                        profileState is PasswordChangeLoading)))
              _buildLoadingIndicator()
            else if (profileState is ProfileLoaded)
              _buildProfileCard(
                context,
                profileState.userProfile,
                (profileState is ProfileFullUpdating ||
                    profileState is PasswordChangeLoading),
                navigateToEditScreen,
                cardAndDividerColor, // 카드 배경색으로 사용할 색상 전달
              )
            else if (profileState is ProfileError)
              _buildErrorView(
                context,
                profileState.message,
                profileState.previousProfile,
                () {
                  profileNotifier.loadUserProfile();
                },
              )
            else
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('프로필 정보를 표시할 수 없습니다.'),
                ),
              ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Divider(
                height: 1,
                thickness: 1,
                color: cardAndDividerColor,
              ), // 구분선 색상
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0), // 인증 기록 타이틀 아래 여백
              child: Text('인증 기록', style: AppTextStyle.bold),
            ),
            _buildHistoryItem(
              context,
              date: '2025/04/30',
              place: '하이테크 1층',
              success: true,
              cardColor: cardAndDividerColor,
            ),
            _buildHistoryItem(
              context,
              date: '2025/04/29',
              place: '60주년 1층',
              success: false,
              cardColor: cardAndDividerColor,
            ),
            _buildHistoryItem(
              context,
              date: '2025/04/27',
              place: '하이테크 2층',
              success: true,
              cardColor: cardAndDividerColor,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 60.0),
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }

  Widget _buildErrorView(
    BuildContext context,
    String message,
    UserProfileEntity? previousProfile,
    VoidCallback onRetry,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.redAccent,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              '오류',
              style: AppTextStyle.bold.copyWith(
                fontSize: 18,
                color: Colors.red.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyle.regular.copyWith(color: Colors.grey[700]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh_rounded, size: 20),
              label: Text('다시 시도', style: AppTextStyle.medium),
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    UserProfileEntity profile,
    bool isOverallUpdating,
    Function(UserProfileEntity) onCardTap,
    Color cardBackgroundColor, // 히스토리 카드와 동일한 배경색을 받도록 함
  ) {
    ImageProvider profileImageProvider;
    bool isNetworkImage = false;

    if (profile.profileImageUrl != null &&
        profile.profileImageUrl!.isNotEmpty &&
        (profile.profileImageUrl!.startsWith('http://') ||
            profile.profileImageUrl!.startsWith('https://'))) {
      profileImageProvider = NetworkImage(profile.profileImageUrl!);
      isNetworkImage = true;
    } else {
      profileImageProvider = const AssetImage(
        ProfileScreen.defaultProfileAssetPath,
      );
    }

    // 프로필 카드 내 텍스트 스타일
    final TextStyle nameTextStyle = AppTextStyle.bold.copyWith(
      fontSize: 17,
      color: Colors.black87,
    );
    final TextStyle subTextStyle = AppTextStyle.bold.copyWith(
      fontSize: 14,
      color: Colors.black54,
    );

    // *** 프로필 이미지 크기 변경 (예: 80x80) ***
    const double profileImageSize = 80.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 0,
      color: cardBackgroundColor, // 카드 자체의 배경은 회색 유지
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: cardBackgroundColor, width: 1.0),
      ),
      child: InkWell(
        onTap: () => onCardTap(profile),
        borderRadius: BorderRadius.circular(10.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    // *** 변경된 부분: 프로필 이미지 컨테이너 크기 조절 ***
                    width: profileImageSize,
                    height: profileImageSize,
                    child: ClipOval(
                      child: Container(
                        color: Colors.white, // 이미지 영역 배경을 흰색으로 설정
                        child: Image(
                          image: profileImageProvider,
                          // *** 변경된 부분: BoxFit.cover -> BoxFit.contain ***
                          fit: BoxFit.contain, // 이미지가 잘리지 않도록 변경
                          // *** 변경된 부분: Image 위젯 크기도 조절 ***
                          width: profileImageSize,
                          height: profileImageSize,
                          errorBuilder: (context, error, stackTrace) {
                            if (isNetworkImage) {
                              print(
                                "ProfileScreen: Failed to load network image. Using default. Error: $error",
                              );
                              return Image.asset(
                                ProfileScreen.defaultProfileAssetPath,
                                fit: BoxFit.contain, // 에러 시에도 contain 유지
                                // *** 변경된 부분: 에러 시 기본 이미지 크기도 조절 ***
                                width: profileImageSize,
                                height: profileImageSize,
                              );
                            }
                            return Container(
                              // *** 변경된 부분: 에러 시 아이콘 컨테이너 크기도 조절 ***
                              width: profileImageSize,
                              height: profileImageSize,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.person,
                                // *** 변경된 부분: 아이콘 크기도 비율에 맞게 조절 (선택 사항) ***
                                size: profileImageSize * 0.6,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "이름: ${profile.name}",
                          style: nameTextStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '포인트: ${profile.totalPoint}p',
                          style: subTextStyle,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '나무 이름: ${profile.nickname}',
                          style: subTextStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey[400],
                  size: 18,
                ),
              ),
              if (isOverallUpdating)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: cardBackgroundColor.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItem(
    BuildContext context, {
    required String date,
    required String place,
    required bool success,
    required Color cardColor,
  }) {
    final TextStyle historyTitleStyle = AppTextStyle.medium.copyWith(
      fontSize: 14,
      color: Colors.black87,
    );
    final TextStyle historySubTitleStyle = AppTextStyle.regular.copyWith(
      fontSize: 12,
      color: Colors.grey[700],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Card(
        elevation: 0,
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListTile(
          leading: Icon(
            success ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: success ? AppColors.primary : Colors.redAccent,
            size: 28,
          ),
          title: Text('날짜: $date', style: historyTitleStyle),
          subtitle: Text('장소: $place', style: historySubTitleStyle),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: Colors.grey[400],
          ),
          onTap: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('$date 기록 상세 보기 (구현 예정)')));
          },
          contentPadding: const EdgeInsets.symmetric(
            vertical: 6.0,
            horizontal: 16.0,
          ),
        ),
      ),
    );
  }
}
