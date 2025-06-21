// lib/features/scan/ui/processing_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primero/features/scan/providers/scan_provider.dart';
import 'package:primero/features/scan/ui/result_screen.dart';

// ✨ 타이머 관리를 위해 ConsumerStatefulWidget으로 변경
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
  // --- 발표용 임시 코드 ---
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // 5초 후에 결과 화면으로 자동 전환하는 타이머 설정
    _timer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
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
    _timer?.cancel(); // 화면이 없어질 때 타이머 정리
    super.dispose();
  }
  // --- 여기까지 ---

  @override
  Widget build(BuildContext context) {
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
