import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          Container(color: Colors.white),
          SafeArea(
            child: profileState.when(
              initial: () => const Center(child: CircularProgressIndicator()),
              loading: () => const Center(child: CircularProgressIndicator()),
              // ✨ 수정된 부분: 이제 loaded 콜백은 userProfile 하나만 받습니다.
              loaded: (userProfile) {
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
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                            onItemTapped(0);
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        16.0,
                        16.0,
                        16.0,
                        32.0,
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 12.0,
                        runSpacing: 8.0,
                        children: [
                          ElevatedButton(
                            child: const Text("임시 성공"),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => ResultScreen(
                                        isSuccess: true,
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
              error:
                  (message, previousProfile) =>
                      Center(child: Text('프로필을 불러오는 중 오류가 발생했습니다: $message')),
            ),
          ),
        ],
      ),
    );
  }
}
