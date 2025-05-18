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
  static const String defaultProfileAssetPath = 'assets/images/babyTree2.png';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileNotifierProvider);
    final profileNotifier = ref.read(profileNotifierProvider.notifier);

    void showMenuComingSoonSnackBar() {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('메뉴 기능 구현 예정입니다.')));
    }

    void navigateToEditScreen(UserProfileEntity profile) {
      context.pushNamed(AppRouteNames.profileEdit, extra: profile);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 프로필'),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: showMenuComingSoonSnackBar,
            tooltip: '메뉴',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await profileNotifier.loadUserProfile();
        },
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

            const Divider(height: 30, thickness: 1, indent: 16, endIndent: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text('인증 기록', style: AppTextStyle.bold),
            ),
            ListTile(
              leading: Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 30,
              ),
              title: const Text('날짜: 2025/04/30'),
              subtitle: const Text('장소: 하이테크 1층'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                /* 상세 기록 보기 */
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    // 이전과 동일
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 50.0),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorView(
    BuildContext context,
    String message,
    UserProfileEntity? previousProfile,
    VoidCallback onRetry,
  ) {
    // 이전과 동일
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 50),
            const SizedBox(height: 16),
            Text(
              '오류: $message',
              textAlign: TextAlign.center,
              style: AppTextStyle.regular.copyWith(color: Colors.red.shade700),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('다시 시도'),
              onPressed: onRetry,
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
  ) {
    ImageProvider profileImage;
    // profileImageUrl이 null이 아니고, 비어있지 않으며, 유효한 http/https URL인지 확인
    if (profile.profileImageUrl != null &&
        profile.profileImageUrl!.isNotEmpty &&
        (profile.profileImageUrl!.startsWith('http://') ||
            profile.profileImageUrl!.startsWith('https://'))) {
      profileImage = NetworkImage(profile.profileImageUrl!);
    } else {
      // 그렇지 않으면 기본 에셋 이미지 사용
      profileImage = const AssetImage(ProfileScreen.defaultProfileAssetPath);
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: InkWell(
        onTap: () => onCardTap(profile),
        borderRadius: BorderRadius.circular(12.0),
        child: Card(
          elevation: 2,
          color: Colors.white,
          shadowColor: Colors.grey.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 16.0,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.grey[200], // 배경색은 항상 표시
                      backgroundImage: profileImage,
                      // NetworkImage 로드 실패 시 처리 (선택적, 더 정교한 처리가 필요할 수 있음)
                      // onBackgroundImageError 콜백은 AssetImage에는 적용되지 않음.
                      // 따라서 profileImage가 NetworkImage일 때만 의미가 있습니다.
                      // child: profileImage is NetworkImage ? null : Image.asset(ProfileScreen.defaultProfileAssetPath), // 이중 로딩 방지
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            profile.name,
                            style: AppTextStyle.bold.copyWith(
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '포인트: ${profile.totalPoint}p',
                            style: AppTextStyle.regular.copyWith(
                              color: AppColors.darkGray,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '나무 이름: ${profile.nickname}',
                            style: AppTextStyle.regular.copyWith(
                              color: AppColors.darkGray,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.grey[400]),
                  ],
                ),
                if (isOverallUpdating)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
