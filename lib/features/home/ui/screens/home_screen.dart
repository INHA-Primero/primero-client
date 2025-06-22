import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:primero/core/theme/app_text_style.dart';
import 'package:primero/features/home/providers/home_di.dart';
import 'package:primero/features/tree_map/ui/screens/tree_map_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeNotifierProvider);

    return Scaffold(
      body: homeState.when(
        initial: () => const Center(child: Text("Initializing...")),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(message),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed:
                        () =>
                            ref
                                .read(homeNotifierProvider.notifier)
                                .fetchHomeData(),
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            ),
        loaded: (userProfile, characterInfo, isWatering) {
          final level = (characterInfo.exp / 1000).floor() + 1;
          final expPercentage = (characterInfo.exp % 1000) / 1000.0;
          final characterImagePath =
              'assets/images/level${(level > 5) ? 5 : level}.png';
          final double treeHeight = (level >= 5) ? 320 : 250;

          return Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/main_background.png',
                fit: BoxFit.cover,
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _CharacterStatusCard(
                        level: level,
                        nickname: characterInfo.nickname,
                        expPercentage: expPercentage,
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.center, // 자식들을 왼쪽으로 정렬
                        children: [
                          // ✨ [수정] Transform.translate를 사용하여 위젯을 왼쪽으로 이동시킵니다.
                          Transform.translate(
                            // offset의 첫 번째 값(x)을 음수로 주면 왼쪽으로 이동합니다.
                            offset: const Offset(2.0, 0),
                            child: _InfoTextBlock(
                              label: '${characterInfo.wateringChance}번 물주기 >',
                            ),
                          ),
                          const SizedBox(height: 8),
                          _CustomIconButton(
                            iconData: Icons.water_drop_outlined,
                            onPressed: () {
                              if (!isWatering &&
                                  characterInfo.wateringChance > 0) {
                                ref
                                    .read(homeNotifierProvider.notifier)
                                    .waterCharacter();
                              } else if (characterInfo.wateringChance <= 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('물주기 기회가 없습니다.'),
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 12),
                          _CustomIconButton(
                            iconData: Icons.map_outlined,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TreeMapScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const Spacer(),
                      Center(
                        child: Image.asset(
                          characterImagePath,
                          height: treeHeight,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/level1.png',
                              height: 250,
                            );
                          },
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
              // 물주기 애니메이션
              if (isWatering)
                Center(
                  child: Transform.scale(
                    scale: 1.8,
                    child: Lottie.asset(
                      'assets/lottie/watering.json',
                      repeat: false,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

// ✨ UI 수정: 누를 수 없는 작은 파란색 텍스트 블록 위젯
class _InfoTextBlock extends StatelessWidget {
  final String label;

  const _InfoTextBlock({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF67C5E5).withOpacity(0.9), // 이미지와 유사한 파란색
        borderRadius: BorderRadius.circular(20.0), // 둥근 모서리
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: AppTextStyle.bold.copyWith(color: Colors.white, fontSize: 14),
      ),
    );
  }
}

// 원형 아이콘 버튼 위젯 (물주기, 지도 공용)
class _CustomIconButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onPressed;

  const _CustomIconButton({required this.iconData, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50),
      child: CircleAvatar(
        radius: 32,
        backgroundColor: Colors.white.withOpacity(0.9),
        child: Icon(iconData, color: const Color(0xFF90A955), size: 38),
      ),
    );
  }
}

class _CharacterStatusCard extends StatelessWidget {
  final int level;
  final String nickname;
  final double expPercentage;

  const _CharacterStatusCard({
    required this.level,
    required this.nickname,
    required this.expPercentage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Card(
        elevation: 4.0,
        color: const Color(0xFFFFF9E8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFD4A373), width: 3),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF90A955),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Lv.$level',
                      style: AppTextStyle.bold.copyWith(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      nickname,
                      style: AppTextStyle.bold.copyWith(
                        fontSize: 20,
                        color: const Color(0xFF333D29),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: expPercentage,
                  minHeight: 12,
                  backgroundColor: Colors.black12,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF4CAF50),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${(expPercentage * 100).toInt()}%',
                  style: AppTextStyle.medium.copyWith(
                    fontSize: 12,
                    color: const Color(0xFF333D29),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
