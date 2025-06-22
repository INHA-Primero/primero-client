// lib/features/scan/ui/scan_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:primero/core/theme/app_text_style.dart';
import 'package:primero/features/profile/providers/profile_di.dart';
import 'package:primero/features/scan/ui/processing_screen.dart';
import 'package:primero/features/scan/ui/result_screen.dart';

// ✨ 타이머 관리를 위해 ConsumerStatefulWidget으로 변경
class ScanScreen extends ConsumerStatefulWidget {
  final Function(int) onItemTapped;

  const ScanScreen({super.key, required this.onItemTapped});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  // --- 발표용 임시 코드 ---
  Timer? _timer;
  bool _navigationTriggered = false;

  void _startNavigationTimer(String barcodeData) {
    // 중복 실행을 방지
    if (_navigationTriggered) return;
    _navigationTriggered = true;

    _timer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (_) => ProcessingScreen(
                  barcode: barcodeData,
                  isSuccessCase: true, // 성공 케이스로 설정
                  onItemTapped: widget.onItemTapped,
                ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // 화면이 없어질 때 타이머 정리
    super.dispose();
  }
  // --- 여기까지 ---

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/images/scan_background.png", fit: BoxFit.cover),
          SafeArea(
            child: profileState.when(
              loading:
                  () => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
              error:
                  (e, s) => Center(
                    child: Text(
                      "오류: $e",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
              initial:
                  () => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
              loaded: (userProfile) {
                final barcodeData =
                    'INHA${userProfile.userId.toString().padLeft(8, '0')}';

                // --- 발표용 임시 코드 ---
                // build가 완료된 직후 타이머를 시작합니다.
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _startNavigationTimer(barcodeData);
                });
                // --- 여기까지 ---

                return Column(
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
                            if (Navigator.canPop(context))
                              Navigator.pop(context);
                            widget.onItemTapped(0);
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          const Image(
                            image: AssetImage("assets/images/babyTree.png"),
                            width: 60,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "${userProfile.name}님의 바코드",
                            style: AppTextStyle.bold.copyWith(
                              color: Colors.black,
                              fontSize: 22,
                            ),
                          ),
                          const SizedBox(height: 100),
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(12),
                            child: BarcodeWidget(
                              barcode: Barcode.code128(),
                              data: barcodeData,
                              width: 300,
                              height: 120,
                              drawText: false,
                            ),
                          ),
                          const SizedBox(height: 40),
                          const Text(
                            "바코드 스캐너에 인식시켜주세요!",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(flex: 2),
                        ],
                      ),
                    ),
                    // --- 발표용 임시 코드 ---
                    // 임시 버튼들을 담고 있던 Padding과 Wrap 위젯을 삭제합니다.
                    // --- 여기까지 ---
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
