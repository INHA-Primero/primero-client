// lib/features/scan/ui/processing_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primero/features/home/providers/home_di.dart'; // 홈 데이터 새로고침을 위해 import
import 'package:primero/features/profile/providers/recycle_history_provider.dart'; // 프로필 기록 새로고침을 위해 import
import 'package:primero/features/scan/ui/result_screen.dart';

class ProcessingScreen extends ConsumerStatefulWidget {
  final String barcode;
  final bool isSuccessCase;
  final Function(int) onItemTapped;

  const ProcessingScreen({
    super.key,
    required this.barcode,
    required this.isSuccessCase,
    required this.onItemTapped,
  });

  @override
  ConsumerState<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends ConsumerState<ProcessingScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // 5초 후에 결과 화면으로 전환
    _timer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        // --- ✨ [핵심 수정] 상태 업데이트 로직 추가 ---
        // 성공 케이스일 때만 데이터 새로고침을 호출합니다.
        if (widget.isSuccessCase) {
          // 1. 홈 화면 데이터(물주기 횟수 등)를 새로고침합니다.
          ref.read(homeNotifierProvider.notifier).fetchHomeData();
          // 2. 프로필 화면의 최근 인증 기록을 새로고침합니다.
          ref.refresh(recentRecycleHistoryProvider);
        }
        // --- 여기까지 ---

        // 결과 화면으로 이동
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => ResultScreen(
                  isSuccess: widget.isSuccessCase,
                  onItemTapped: widget.onItemTapped,
                ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // build 메소드는 기존과 동일
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
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 250),

                        CircularProgressIndicator(color: Colors.black),
                        SizedBox(height: 24),
                        Text(
                          "AI가 플라스틱을 분석중입니다...",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
