import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:primero/core/theme/app_text_style.dart';
import 'package:primero/features/profile/providers/profile_di.dart';
import 'package:primero/features/scan/ui/processing_screen.dart';
import 'package:primero/features/scan/ui/result_screen.dart';

class ScanScreen extends ConsumerWidget {
  final Function(int) onItemTapped;

  const ScanScreen({super.key, required this.onItemTapped});

  void _navigateToProcessing(
    BuildContext context,
    String barcodeData,
    bool isSuccess,
    bool isTestMode,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => ProcessingScreen(
              barcode: barcodeData,
              isSuccessCase: isSuccess,
              onItemTapped: onItemTapped,
              isTestMode: isTestMode,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              // ✨✨✨ 오류 수정: (userProfile, authLogs) 두 개의 파라미터를 받도록 수정 ✨✨✨
              loaded: (userProfile, authLogs) {
                // authLogs는 이 화면에서 사용하지 않으므로 무시합니다.
                final barcodeData =
                    'INHA${userProfile.userId.toString().padLeft(8, '0')}';

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
                            // 1. 현재 ScanScreen을 닫아서 이전 화면(MainScaffold)으로 돌아갑니다.
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                            // 2. MainScaffold에게 홈(0번 탭)으로 이동하라고 알립니다.
                            onItemTapped(0);
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          const Image(
                            image: AssetImage("assets/images/babyTree.png"),
                            width: 60,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "${userProfile.name ?? '사용자'}님의 바코드",
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
                          const Spacer(),
                          const Padding(
                            padding: EdgeInsets.only(
                              bottom: 20.0,
                            ), // 텍스트가 잘리지 않도록 여백 추가
                            child: Text(
                              "바코드 스캐너에 인식시켜주세요!",
                              style: TextStyle(
                                // AppTextStyle 대신 기본 TextStyle 사용 (배경 이미지에 따라 가독성 조절)
                                color: Colors.black87,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        16.0,
                        16.0,
                        16.0,
                        32.0,
                      ), // 하단 여백 추가
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 12.0,
                        runSpacing: 8.0,
                        children: [
                          ElevatedButton(
                            child: const Text("임시 성공"),
                            onPressed: () {
                              // 로딩 화면을 건너뛰고 바로 성공 화면으로 이동
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => ResultScreen(
                                        isSuccess: true, // 성공 결과로 고정
                                        onItemTapped: onItemTapped,
                                      ),
                                ),
                              );
                            },
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text("임시 실패"),
                            onPressed:
                                () => _navigateToProcessing(
                                  context,
                                  barcodeData,
                                  false,
                                  false,
                                ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                            ),
                            child: const Text("로딩 테스트"),
                            onPressed:
                                () => _navigateToProcessing(
                                  context,
                                  barcodeData,
                                  true,
                                  true,
                                ),
                          ),
                        ],
                      ),
                    ),
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
