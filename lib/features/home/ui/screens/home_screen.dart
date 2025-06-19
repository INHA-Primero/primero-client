import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:primero/core/theme/app_text_style.dart';
import 'package:primero/features/home/providers/home_di.dart';

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
          final level = (characterInfo.exp / 100).floor() + 1;
          final currentExp = characterInfo.exp % 100;
          final expPercentage = currentExp / 100.0;

          final characterImageLevel = (level > 5) ? 5 : level;
          final characterImagePath =
              'assets/images/level$characterImageLevel.png';

          return Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/main_background.png',
                fit: BoxFit.cover,
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _CharacterStatusCard(
                            level: level,
                            nickname: characterInfo.nickname,
                            expPercentage: expPercentage,
                          ),
                          const SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _CircularButton(
                                iconData: Icons.water_drop_outlined,
                                label: '${characterInfo.wateringChance}번 물주기 >',
                                onPressed: () {
                                  if (!isWatering &&
                                      characterInfo.wateringChance > 0) {
                                    ref
                                        .read(homeNotifierProvider.notifier)
                                        .waterCharacter();
                                  } else if (characterInfo.wateringChance <=
                                      0) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('물주기 기회가 없습니다.'),
                                      ),
                                    );
                                  }
                                },
                              ),
                              const SizedBox(height: 12),
                              _CircularButton(
                                iconData: Icons.map_outlined,
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('지도 기능은 준비 중입니다.'),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      Center(
                        child: Image.asset(
                          characterImagePath,
                          height: 250,
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
              // if (isWatering)
              //   // 여기에 Positioned 위젯을 추가하여 Lottie 애니메이션의 위치를 조정합니다.
              //   Positioned(
              //     // top 값을 조정하여 Lottie 애니메이션을 아래로 내릴 수 있습니다.
              //     // 전체 화면 높이의 비율(0.4 = 40%) 또는 고정 값(예: 300.0)을 사용할 수 있습니다.
              //     // 화면 하단에 가깝게 하려면 top 값을 늘리거나 bottom 값을 줄이세요.
              //     // 예를 들어, 화면 하단에서 100 픽셀 위에 배치하려면 bottom: 100.0으로 설정합니다.
              //     // top:
              //     //     MediaQuery.of(context).size.height *
              //     //     0.01, // 55% 지점에서 시작 (이 값을 조절)
              //     // left: 0, // 가로 중앙 정렬을 위해 left와 right를 0으로 설정
              //     // right: 0,
              //     child: Container(
              //       alignment: Alignment.center, // Container 내에서 Lottie를 중앙에 배치
              //       child: Lottie.asset(
              //         'assets/lottie/watering.json',
              //         width: 3000,
              //         height: 3000,
              //         repeat: false, // Lottie가 Container 내부에 맞춰지도록 설정
              //       ),
              //     ),
              //   ),
              if (isWatering)
                Positioned(
                  // Positioned 위젯은 Container의 '위치'를 결정합니다.
                  // top, bottom, left, right를 모두 지정하면 Container는 Stack의 해당 영역을 채웁니다.
                  // 예를 들어, top:0, bottom:0, left:0, right:0 이면 Stack 전체를 채웁니다.
                  top:
                      MediaQuery.of(context).size.height *
                      0.01, // 상단에서 55% 지점 (이 값을 조절)
                  left: 0,
                  right: 0,
                  child: Container(
                    // 여기서 Container의 크기를 직접 지정할 수 있습니다.
                    // 명시적으로 width와 height를 설정합니다.

                    // 옵션 1: Lottie가 화면 하단 근처에서 크게 보이도록 Container의 높이를 명시적으로 지정
                    //        가로는 left:0, right:0으로 이미 화면 폭 전체를 차지합니다.
                    height:
                        MediaQuery.of(context).size.height *
                        1.0, // 화면 높이의 40%로 Container 높이 설정 (조절 가능)
                    // Lottie 애니메이션의 원하는 최대 높이에 따라 이 값을 조절하세요.
                    alignment: Alignment.center, // Container 내에서 Lottie를 중앙에 배치

                    child: Lottie.asset(
                      'assets/lottie/watering.json',
                      // Lottie의 width/height는 이제 부모 Container의 명시된 크기 내에서 동작합니다.
                      // Container가 충분히 커지면, Lottie의 width/height는 원하는 최대 크기를 지정할 수 있습니다.
                      // 다만, Lottie의 width/height가 Container의 크기보다 크면 잘릴 수 있습니다.
                      // 일반적으로 Lottie의 width/height는 Container에 fit하도록 설정하거나,
                      // Container의 크기에 맞춰 null로 두는 경우가 많습니다.
                      // 여기서는 Container 크기에 맞춰질 것이므로, Lottie의 width/height를 제거하거나 적절히 조절합니다.
                      width:
                          1000, // Lottie 애니메이션 자체의 원하는 너비 (Container 높이와 비율에 맞게 조절)
                      height:
                          1000, // Lottie 애니메이션 자체의 원하는 높이 (Container 높이와 비율에 맞게 조절)
                      repeat: false,
                      fit:
                          BoxFit
                              .contain, // Lottie가 Container 내부에 비율을 유지하며 맞춰지도록 설정
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

class _CircularButton extends StatelessWidget {
  final IconData iconData;
  final String? label;
  final VoidCallback? onPressed;

  const _CircularButton({required this.iconData, this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(iconData, color: const Color(0xFF90A955)),
          ),
          if (label != null)
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                label!,
                style: AppTextStyle.medium.copyWith(fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }
}
