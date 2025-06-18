import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        error: (message) => Center(child: Text(message)),
        loaded: (userProfile, characterInfo) {
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
                                label:
                                    '${characterInfo.wateringChance}번 물주기 >',
                                onPressed: () {
                                  // TODO: Implement watering logic
                                },
                              ),
                              const SizedBox(height: 12),
                              _CircularButton(
                                iconData: Icons.map_outlined,
                                onPressed: () {
                                  // TODO: Implement map navigation
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
                            return Image.asset('assets/images/level1.png',
                                height: 250);
                          },
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(height: 80),
                    ],
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
    // 💡 Card를 SizedBox로 감싸 너비를 지정하여 크기와 정렬 문제를 해결합니다.
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.65,
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF90A955),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Lv.$level',
                      style: AppTextStyle.bold
                          .copyWith(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 💡 닉네임이 길 경우 줄바꿈 대신 ...으로 표시되도록 합니다.
                  Expanded(
                    child: Text(
                      nickname,
                      style: AppTextStyle.bold
                          .copyWith(fontSize: 20, color: const Color(0xFF333D29)),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // 💡 경험치 게이지는 이제 Card의 너비를 따라갑니다.
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: expPercentage,
                  minHeight: 12,
                  backgroundColor: Colors.black12,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                ),
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${(expPercentage * 100).toInt()}%',
                  style: AppTextStyle.medium
                      .copyWith(fontSize: 12, color: const Color(0xFF333D29)),
                ),
              )
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
  final VoidCallback onPressed;

  const _CircularButton(
      {required this.iconData, this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                label!,
                style:
                    AppTextStyle.bold.copyWith(fontSize: 12, color: Colors.white),
              ),
            ),
          ),
        GestureDetector(
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                )
              ],
            ),
            child: Icon(
              iconData,
              size: 32,
              color: const Color(0xFF5C6BC0),
            ),
          ),
        ),
      ],
    );
  }
}
