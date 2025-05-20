// lib/features/profile/presentation/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primero/core/theme/app_colors.dart'; // AppColors 사용
import 'package:primero/core/theme/app_text_style.dart'; // AppTextStyle 사용
import 'package:primero/features/profile/domain/entities/user_profile_entity.dart';
import 'package:primero/features/profile/presentation/providers/profile_di.dart';
import 'package:primero/features/profile/presentation/providers/profile_state.dart';
import 'package:go_router/go_router.dart';
// 수정된 라우터 파일 경로
import 'package:primero/app/app_router.dart'; // AppRouteNames 사용

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  // 기본 프로필 이미지 경로 (assets 폴더에 해당 파일이 있어야 함)
  static const String defaultProfileAssetPath =
      'assets/images/babyTree2.png'; // 실제 경로 확인

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileNotifierProvider);
    final profileNotifier = ref.read(profileNotifierProvider.notifier);

    // Hex Color F3F4F5
    const Color cardAndDividerColor = Color(0xFFF3F4F5);

    void showMenuComingSoonSnackBar() {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('메뉴 기능 구현 예정입니다.')));
    }

    void navigateToEditScreen(UserProfileEntity profile) {
      context.pushNamed(AppRouteNames.profileEdit, extra: profile);
    }

    return Scaffold(
      backgroundColor: Colors.white, // 1. 전체 화면 배경 흰색
      appBar: AppBar(
        title: Text(
          // 1. AppBar 타이틀
          '나의 프로필',
          style: AppTextStyle.bold.copyWith(
            fontSize: 24,
            color: Colors.black87,
          ), // 더 굵게, 크기 조절
        ),
        centerTitle: false, // 타이틀 왼쪽 정렬 (기본값은 플랫폼에 따라 다를 수 있음)
        titleSpacing: 20.0, // 왼쪽 패딩 조절 (기본값은 NavigationToolbar.kMiddleSpacing)
        toolbarHeight: 60.0, // AppBar 높이 약간 아래로 내리는 효과 (기본값 56.0)
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0), // 아이콘 오른쪽 여백
            child: IconButton(
              icon: const Icon(
                Icons.menu_rounded,
                color: Colors.black54,
                size: 28,
              ), // 채워진 메뉴 아이콘, 크기 및 색상 조절
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
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            if (profileState is ProfileInitial ||
                (profileState is ProfileLoading &&
                    !(profileState is ProfileInfoUpdating ||
                        profileState is PasswordChangeLoading)))
              _buildLoadingIndicator()
            else if (profileState is ProfileLoaded)
              _buildProfileCard(
                context,
                profileState.userProfile,
                (profileState is ProfileInfoUpdating ||
                    profileState is PasswordChangeLoading),
                navigateToEditScreen,
                cardAndDividerColor,
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

            // 6. 인증 기록으로 넘어가는 구분선
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 20.0,
              ), // 구분선 위아래 여백 증가
              child: Divider(
                height: 1,
                thickness: 1,
                color: cardAndDividerColor,
              ), // 요청하신 색상으로 변경
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20.0, 0, 16.0, 12.0), // 제목 왼쪽 패딩 증가
              child: Text('인증 기록', style: AppTextStyle.bold),
            ),
            // TODO: 실제 인증 기록 리스트 구현
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
            // 더 많은 히스토리 아이템 예시 (스크롤 확인용)
            _buildHistoryItem(
              context,
              date: '2025/04/25',
              place: '2호관 앞',
              success: true,
              cardColor: cardAndDividerColor,
            ),
            _buildHistoryItem(
              context,
              date: '2025/04/23',
              place: '학생회관',
              success: false,
              cardColor: cardAndDividerColor,
            ),
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
    Color cardBackgroundColor,
  ) {
    ImageProvider profileImageProvider;
    if (profile.profileImageUrl != null &&
        profile.profileImageUrl!.isNotEmpty &&
        (profile.profileImageUrl!.startsWith('http://') ||
            profile.profileImageUrl!.startsWith('https://'))) {
      profileImageProvider = NetworkImage(profile.profileImageUrl!);
    } else {
      profileImageProvider = const AssetImage(
        ProfileScreen.defaultProfileAssetPath,
      );
    }

    // 3. 프로필 카드 내 텍스트 스타일
    final TextStyle cardTextStyle = AppTextStyle.bold.copyWith(
      fontSize: 16,
      color: Colors.black87,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16.0,
        8.0,
        16.0,
        8.0,
      ), // AppBar와 카드 사이 간격 조절
      child: InkWell(
        onTap: () => onCardTap(profile),
        borderRadius: BorderRadius.circular(16.0),
        child: Card(
          elevation: 0,
          color: cardBackgroundColor, // 2. 프로필 카드 배경색 적용
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 20.0,
            ),
            child: Stack(
              // Stack을 사용하여 아이콘을 오른쪽 상단에 배치
              alignment: Alignment.center, // 기본 정렬
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white,
                      backgroundImage: profileImageProvider,
                      onBackgroundImageError: (_, __) {
                        print(
                          "ProfileScreen: Failed to load network image for profile card.",
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            profile.name,
                            style: cardTextStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '포인트: ${profile.totalPoint}p',
                            style: cardTextStyle,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '나무 이름: ${profile.nickname}',
                            style: cardTextStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // 4. 네비게이션 아이콘은 Row의 일부로 두어 수직 중앙 정렬 유지
                    // Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey[500], size: 20),
                  ],
                ),
                // 4. 프로필 변경 화면으로 들어가는 아이콘을 오른쪽 상단에 위치
                Positioned(
                  top: 0,
                  right: 0,
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey[600],
                    size: 22,
                  ), // 아이콘 색상 및 크기 조절
                ),
                if (isOverallUpdating)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        // 카드 배경색과 유사하게 하되 약간의 투명도
                        color: cardBackgroundColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12.0),
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
      ),
    );
  }

  // 6. 인증 기록 블록들 색상 및 스타일 적용
  Widget _buildHistoryItem(
    BuildContext context, {
    required String date,
    required String place,
    required bool success,
    required Color cardColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 5.0,
      ), // 아이템 간 간격
      child: Card(
        elevation: 0,
        color: cardColor, // 2. 인증 기록 카드 배경색 적용
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          leading: Icon(
            // 5. 아이콘 굵기/스타일
            success
                ? Icons.check_circle_rounded
                : Icons.cancel_rounded, // 채워진 아이콘
            color: success ? AppColors.primary : Colors.redAccent,
            size: 28, // 아이콘 크기 조절
          ),
          title: Text(
            '날짜: $date',
            style: AppTextStyle.medium.copyWith(
              fontSize: 13,
              color: Colors.black87,
            ),
          ), // 폰트 크기 약간 줄임
          subtitle: Text(
            '장소: $place',
            style: AppTextStyle.regular.copyWith(
              fontSize: 11,
              color: Colors.grey[700],
            ),
          ), // 폰트 크기 약간 줄임
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: Colors.grey[500],
          ),
          onTap: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('$date 기록 상세 보기 (구현 예정)')));
          },
          contentPadding: const EdgeInsets.symmetric(
            vertical: 6.0,
            horizontal: 16.0,
          ), // 내부 패딩 조절
          dense: true, // ListTile을 좀 더 컴팩트하게
        ),
      ),
    );
  }
}
