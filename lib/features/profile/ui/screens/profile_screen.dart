import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:primero/core/theme/app_colors.dart';
import 'package:primero/core/theme/app_text_style.dart';
import 'package:primero/features/auth/providers/auth_di.dart';
import 'package:primero/features/inquiry/ui/screens/inquiry_list_screen.dart';
import 'package:primero/features/profile/models/recycle_history_model.dart';
import 'package:primero/features/profile/models/user_profile_model.dart';
import 'package:primero/features/profile/providers/profile_di.dart';
import 'package:primero/features/profile/providers/recycle_history_provider.dart';
import 'package:primero/features/profile/ui/screens/profile_edit_screen.dart';

// 버전 정보를 위한 Provider
final packageInfoProvider = FutureProvider.autoDispose<PackageInfo>((
  ref,
) async {
  return PackageInfo.fromPlatform();
});

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static const String defaultProfileAssetPath =
      'assets/images/defaultProfileImage.png';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileNotifierProvider);
    final historyState = ref.watch(
      recentRecycleHistoryProvider,
    ); // 수정된 Provider 사용
    final profileNotifier = ref.read(profileNotifierProvider.notifier);
    const Color cardAndDividerColor = Color(0xFFF3F4F5);

    void navigateToEditScreen(UserProfileModel profile) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ProfileEditScreen(initialProfile: profile),
        ),
      );
    }

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
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                  tooltip: '메뉴',
                ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      endDrawer: Drawer(
        child: Column(
          children: [
            // ✨ [UI 수정 1] DrawerHeader를 좀 더 간결하게 수정
            Container(
              width: double.infinity,
              height: 120, // 높이를 줄여 공간 확보
              color: AppColors.primary,
              child: const Align(
                alignment: Alignment(-0.8, 0.5), // 텍스트 위치 미세 조정
                child: Text(
                  '메뉴',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20, // 폰트 크기 축소
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10), // 메뉴 아이템 간 상단 여백
            ListTile(
              leading: const Icon(
                Icons.support_agent_rounded,
                color: AppColors.darkGray,
              ),
              // ✨ [UI 수정 1] ListTile 텍스트 스타일 적용
              title: Text(
                '문의하기',
                style: AppTextStyle.medium.copyWith(fontSize: 15),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const InquiryListScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              // ✨ [UI 수정 1] ListTile 텍스트 스타일 적용
              title: Text(
                '로그아웃',
                style: AppTextStyle.medium.copyWith(fontSize: 15),
              ),
              onTap: () {
                Navigator.pop(context);
                ref.read(authNotifierProvider.notifier).logout();
              },
            ),
            const Spacer(),
            _buildDrawerFooter(),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await profileNotifier.loadUserProfile();
          ref.refresh(recentRecycleHistoryProvider); // 수정된 Provider 사용
        },
        color: AppColors.primary,
        child: profileState.when(
          initial: () => _buildLoadingIndicator(),
          loading: () => _buildLoadingIndicator(),
          loaded:
              (userProfile) => ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                children: <Widget>[
                  _buildProfileCard(
                    context,
                    userProfile,
                    navigateToEditScreen,
                    cardAndDividerColor,
                  ),
                  // ✨ [UI 수정 2] 사라졌던 구분선(Divider) 다시 추가
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: cardAndDividerColor,
                    ),
                  ),
                  Text(
                    '인증 기록', // '인증 기록' -> '최근 인증 기록'으로 텍스트 수정
                    style: AppTextStyle.bold.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  historyState.when(
                    data:
                        (historyData) => _buildHistoryList(historyData.content),
                    loading: () => _buildLoadingIndicator(),
                    error:
                        (error, stack) =>
                            Center(child: Text('인증 기록을 불러오지 못했습니다.\n$error')),
                  ),
                ],
              ),
          error:
              (message, previousProfile) => _buildErrorView(
                context,
                message,
                () => profileNotifier.loadUserProfile(),
              ),
        ),
      ),
    );
  }

  // --- 이하 위젯 빌더 함수들은 변경사항 없습니다 ---

  Widget _buildHistoryList(List<RecycleListItem> items) {
    if (items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text('표시할 인증 기록이 없습니다.', style: TextStyle(color: Colors.grey)),
        ),
      );
    }
    return Column(
      children: [for (final item in items) _RecycleHistoryItem(item: item)],
    );
  }

  Widget _buildDrawerFooter() {
    return Consumer(
      builder: (context, ref, child) {
        final packageInfoAsync = ref.watch(packageInfoProvider);
        final footerTextStyle = TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        );
        void showComingSoonSnackBar(String featureName) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('$featureName 기능은 준비 중입니다.')));
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              packageInfoAsync.when(
                data:
                    (info) => Text(
                      'App Version: ${info.version} (${info.buildNumber})',
                      style: footerTextStyle,
                    ),
                loading:
                    () => const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2.0),
                    ),
                error: (e, s) => Text('버전 정보 로딩 실패', style: footerTextStyle),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => showComingSoonSnackBar('서비스 이용약관'),
                    child: Text('Terms of Service', style: footerTextStyle),
                  ),
                  Text('  ·  ', style: footerTextStyle),
                  InkWell(
                    onTap: () => showComingSoonSnackBar('개인정보 처리방침'),
                    child: Text('Privacy Policy', style: footerTextStyle),
                  ),
                ],
              ),
            ],
          ),
        );
      },
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
                      errorBuilder:
                          (context, error, stackTrace) => Image.asset(
                            defaultProfileAssetPath,
                            fit: BoxFit.contain,
                            width: profileImageSize,
                            height: profileImageSize,
                          ),
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
}

class _RecycleHistoryItem extends ConsumerStatefulWidget {
  final RecycleListItem item;
  const _RecycleHistoryItem({required this.item});

  @override
  ConsumerState<_RecycleHistoryItem> createState() =>
      __RecycleHistoryItemState();
}

class __RecycleHistoryItemState extends ConsumerState<_RecycleHistoryItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      elevation: 0,
      color: const Color(0xFFF3F4F5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        onExpansionChanged: (isExpanding) {
          setState(() {
            _isExpanded = isExpanding;
          });
        },
        leading: Icon(
          item.result ? Icons.check_circle_rounded : Icons.cancel_rounded,
          color: item.result ? AppColors.primary : Colors.redAccent,
          size: 28,
        ),
        title: Text(
          '날짜: ${DateFormat('yyyy/MM/dd').format(item.takenAt)}',
          style: AppTextStyle.medium.copyWith(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          '장소: ${item.binLocation}',
          style: AppTextStyle.regular.copyWith(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
        trailing: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
        children: [if (_isExpanded) _buildExpandedContent(item.id)],
      ),
    );
  }

  Widget _buildExpandedContent(int id) {
    final detailState = ref.watch(recycleDetailProvider(id));
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      width: double.infinity,
      child: detailState.when(
        data:
            (detail) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (detail.recordImgPath.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        detail.recordImgPath,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => Container(
                              height: 150,
                              color: Colors.grey.shade300,
                              child: const Center(child: Text('이미지 로딩 실패')),
                            ),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 150,
                            color: Colors.grey.shade300,
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                _buildDetailRow(
                  '시각',
                  DateFormat('HH:mm:ss').format(detail.takenAt),
                ),
                _buildDetailRow('인증 결과', detail.result ? '성공' : '실패'),
              ],
            ),
        loading:
            () => const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
        error:
            (error, stack) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(child: Text('상세 정보를 불러올 수 없습니다.')),
            ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyle.regular.copyWith(color: Colors.grey[700]),
          ),
          Text(value, style: AppTextStyle.medium),
        ],
      ),
    );
  }
}
