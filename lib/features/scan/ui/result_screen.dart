import 'package:flutter/material.dart';
import 'package:primero/core/theme/app_colors.dart';
import 'package:primero/core/theme/app_text_style.dart';

class ResultScreen extends StatelessWidget {
  final bool isSuccess;
  final Function(int) onItemTapped;

  const ResultScreen({
    super.key,
    required this.isSuccess,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final String title = isSuccess ? "분리수거 인증 성공!" : "분리수거 인증 실패..";
    final String subtitle =
        isSuccess
            ? "AI가 깨끗한 플라스틱을 스캔했습니다.\n자동으로 포인트가 적립됩니다!"
            : "깨끗한 플라스틱이 아닙니다.\n다음에 다시 도전해주세요.";

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/images/scan_background.png", fit: BoxFit.cover),
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 30,
                      ),
                      onPressed: () {
                        onItemTapped(0);
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Image(
                  image: AssetImage("assets/images/babyTree.png"),
                  width: 60,
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: AppTextStyle.bold.copyWith(
                    color: Colors.black,
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.regular.copyWith(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 100),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isSuccess ? AppColors.primary : Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSuccess ? Icons.check : Icons.close,
                    color: Colors.white,
                    size: 80,
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
