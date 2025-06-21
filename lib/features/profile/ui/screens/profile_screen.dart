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
    final profileNotifier = ref.read(profileNotifierProvider.notifier);

    // ✨ [복원] 실제 분리수거 기록 데이터를 API로 호출합니다.
    final historyState = ref.watch(recentRecycleHistoryProvider);
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
            Container(
              width: double.infinity,
              height: 120,
              color: AppColors.primary,
              child: const Align(
                alignment: Alignment(-0.8, 0.5),
                child: Text(
                  '메뉴',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(
                Icons.support_agent_rounded,
                color: AppColors.darkGray,
              ),
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
        // ✨ [복원] 새로고침 시 인증 기록도 함께 새로고침합니다.
        onRefresh: () async {
          await profileNotifier.loadUserProfile();
          ref.refresh(recentRecycleHistoryProvider);
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
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                      color: Color.fromARGB(255, 230, 229, 229),
                    ),
                  ),
                  Text(
                    '인증 기록',
                    style: AppTextStyle.bold.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  // ✨ [복원] API의 상태(data, loading, error)에 따라 UI를 표시합니다.
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
  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      elevation: 0,
      color: const Color(0xFFF3F4F5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        shape: const Border(),
        collapsedShape: const Border(),
        backgroundColor: const Color(0xFFF3F4F5),
        collapsedBackgroundColor: const Color(0xFFF3F4F5),
        tilePadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
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
        trailing: Icon(Icons.expand_more, key: ValueKey(item.id)),
        children: <Widget>[
          const Divider(height: 1, thickness: 0.5, color: Colors.grey),
          // ✨ [복원] 상세 정보 API를 호출하도록 변경
          _buildExpandedContent(item.id),
        ],
      ),
    );
  }

  // ✨ [복원] 실제 상세 정보 API를 호출하여 UI를 그리는 코드로 복원
  Widget _buildExpandedContent(int id) {
    // API를 호출하여 상세 정보를 가져옵니다.
    final detailState = ref.watch(recycleDetailProvider(id));
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      width: double.infinity,
      child: detailState.when(
        data:
            (detail) => Column(
              // 실제 데이터로 UI 구성
              //child: Image.network(
              //detail.recordImgPath,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (detail
                    .recordImgPath
                    .isNotEmpty) // 이 조건은 유지하여, 실제 데이터가 있을 때만 이미지를 표시하도록 합니다.
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      // ✨ Image.network를 Image.asset으로 변경하고 경로를 지정합니다.
                      child: Image.asset(
                        'assets/images/recycle.png', // 요청하신 임시 이미지 경로
                        width: double.infinity,
                        fit: BoxFit.cover,
                        height: 200,
                        // 로컬 이미지가 없을 경우를 대비한 errorBuilder
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            color: Colors.grey.shade300,
                            child: const Center(
                              child: Text(
                                '이미지를 표시할 수 없습니다.',
                                style: TextStyle(color: Colors.grey),
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
                const SizedBox(height: 4),
                _buildDetailRow('인증 결과', detail.result ? '성공' : '실패'),
              ],
            ),
        loading:
            () => const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
        error:
            (error, stack) => const Padding(
              padding: EdgeInsets.all(16.0),
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
