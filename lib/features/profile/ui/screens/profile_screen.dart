// lib/features/profile/ui/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primero/core/theme/app_colors.dart';
import 'package:primero/core/theme/app_text_style.dart';
import 'package:primero/features/auth/providers/auth_di.dart';
import 'package:primero/features/profile/models/auth_log_res.dart'; // ✨ 1. 인증 로그 모델 Import
import 'package:primero/features/profile/models/user_profile_model.dart';
import 'package:primero/features/profile/providers/profile_di.dart';
import 'package:primero/features/profile/ui/screens/profile_edit_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static const String defaultProfileAssetPath =
      'assets/images/defaultProfileImage.png';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileNotifierProvider);
    final profileNotifier = ref.read(profileNotifierProvider.notifier);
    const Color cardAndDividerColor = Color(0xFFF3F4F5);

    void showMenuComingSoonSnackBar(String featureName) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$featureName 기능은 구현 예정입니다.')));
    }

    void navigateToEditScreen(UserProfileModel profile) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ProfileEditScreen(initialProfile: profile),
        ),
      );
    }

    // ✨ 2. AppBar 수정: 로그아웃 버튼 제거, EndDrawer(메뉴) 열기 기능 추가
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          '나의 프로필',
          style: AppTextStyle.bold.copyWith(
            fontSize: 22,
            color: Colors.black87,
          ),
        ),
        centerTitle: false,
        titleSpacing: 20.0,
        toolbarHeight: 70.0,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          Builder(
            builder:
                (context) => IconButton(
                  icon: const Icon(
                    Icons.menu_rounded,
                    color: Colors.black,
                    size: 28,
                  ),
                  onPressed:
                      () => Scaffold.of(context).openEndDrawer(), // 메뉴 열기
                  tooltip: '메뉴',
                ),
          ),
          const SizedBox(width: 12), // 오른쪽 여백
        ],
      ),
      // ✨ 3. EndDrawer (오른쪽에서 나타나는 메뉴) 추가
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: AppColors.primary),
              child: Text(
                '메뉴',
                style: AppTextStyle.bold.copyWith(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.support_agent_rounded),
              title: const Text('문의하기'),
              onTap: () {
                Navigator.pop(context); // 메뉴 닫기
                showMenuComingSoonSnackBar('문의하기');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('로그아웃'),
              onTap: () {
                Navigator.pop(context); // 메뉴 닫기
                ref.read(authNotifierProvider.notifier).logout();
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await profileNotifier.loadUserProfile();
        },
        color: AppColors.primary,
        child: profileState.when(
          initial: () => _buildLoadingIndicator(),
          loading: () => _buildLoadingIndicator(),
          // ✨ 4. loaded 상태에서 authLogs를 함께 전달받음
          loaded:
              (userProfile, authLogs) => _buildProfileView(
                context,
                userProfile,
                authLogs, // 전달
                navigateToEditScreen,
                cardAndDividerColor,
              ),
          error: (message, previousProfile) {
            return _buildErrorView(
              context,
              message,
              () => profileNotifier.loadUserProfile(),
            );
          },
        ),
      ),
    );
  }

  // ✨ 5. _buildProfileView 메서드가 authLogs 리스트를 받도록 수정
  Widget _buildProfileView(
    BuildContext context,
    UserProfileModel profile,
    List<AuthLogRes> authLogs,
    Function(UserProfileModel) navigateToEditScreen,
    Color cardAndDividerColor,
  ) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      children: <Widget>[
        _buildProfileCard(
          context,
          profile,
          navigateToEditScreen,
          cardAndDividerColor,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Divider(height: 1, thickness: 1, color: cardAndDividerColor),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: Text('인증 기록', style: AppTextStyle.bold),
        ),
        // ✨ 6. 고정된 데이터 대신 API 데이터를 기반으로 인증 기록 리스트를 동적으로 생성
        _buildAuthHistoryList(context, authLogs, cardAndDividerColor),
      ],
    );
  }

  // ✨ 7. 인증 기록 리스트를 동적으로 생성하는 위젯
  Widget _buildAuthHistoryList(
    BuildContext context,
    List<AuthLogRes> logs,
    Color cardColor,
  ) {
    if (logs.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40.0),
          child: Text('아직 인증 기록이 없습니다.'),
        ),
      );
    }
    // API 응답을 기반으로 기록 아이템들을 생성
    return Column(
      children:
          logs
              .map(
                (log) => _buildHistoryItem(
                  context,
                  date: '${log.date} ${log.time}', // 날짜와 시간 결합
                  place: log.location, // API 데이터 사용
                  success: log.success, // API 데이터 사용
                  cardColor: cardColor,
                ),
              )
              .toList(),
    );
  }

  // 나머지 위젯 빌더(_buildLoadingIndicator, _buildErrorView, _buildProfileCard, _buildHistoryItem)는 변경 사항이 없습니다.
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
    UserProfileModel profile,
    Function(UserProfileModel) onCardTap,
    Color cardBackgroundColor,
  ) {
    ImageProvider profileImageProvider;

    if (profile.profileImgPath != null &&
        profile.profileImgPath!.isNotEmpty &&
        (profile.profileImgPath!.startsWith('http://') ||
            profile.profileImgPath!.startsWith('https://'))) {
      profileImageProvider = NetworkImage(profile.profileImgPath!);
    } else {
      profileImageProvider = const AssetImage(defaultProfileAssetPath);
    }

    final TextStyle nameTextStyle = AppTextStyle.bold.copyWith(
      fontSize: 17,
      color: Colors.black87,
    );
    final TextStyle subTextStyle = AppTextStyle.bold.copyWith(
      fontSize: 14,
      color: Colors.black54,
    );
    const double profileImageSize = 80.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 0,
      color: cardBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: cardBackgroundColor, width: 1.0),
      ),
      child: InkWell(
        onTap: () => onCardTap(profile),
        borderRadius: BorderRadius.circular(10.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: profileImageSize,
                height: profileImageSize,
                child: ClipOval(
                  child: Container(
                    color: Colors.white,
                    child: Image(
                      image: profileImageProvider,
                      fit: BoxFit.contain,
                      width: profileImageSize,
                      height: profileImageSize,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          defaultProfileAssetPath,
                          fit: BoxFit.contain,
                          width: profileImageSize,
                          height: profileImageSize,
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
                    Text('포인트: ${profile.totalPoint}p', style: subTextStyle),
                    const SizedBox(height: 6),
                    Text(
                      '나무 이름: ${profile.treeName}',
                      style: subTextStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey[400],
                size: 18,
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
          onTap:
              () => ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('$date 기록 상세 보기 (구현 예정)'))),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 6.0,
            horizontal: 16.0,
          ),
        ),
      ),
    );
  }
}
