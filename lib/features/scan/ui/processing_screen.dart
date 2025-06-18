import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primero/features/scan/providers/scan_provider.dart';
import 'package:primero/features/scan/ui/result_screen.dart';

class ProcessingScreen extends ConsumerStatefulWidget {
  final String barcode;
  final bool isSuccessCase;
  final Function(int) onItemTapped;
  final bool isTestMode;

  const ProcessingScreen({
    super.key,
    required this.barcode,
    required this.isSuccessCase,
    required this.onItemTapped,
    this.isTestMode = false,
  });

  @override
  ConsumerState<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends ConsumerState<ProcessingScreen> {
  @override
  void initState() {
    super.initState();
    if (!widget.isTestMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _executeScanAndNavigate();
      });
    }
  }

  Future<void> _executeScanAndNavigate() async {
    bool apiCallSuccess;
    try {
      await ref
          .read(scanRepositoryProvider)
          .logScanResult(
            barcode: widget.barcode,
            success: widget.isSuccessCase,
            location: "Inha University",
          );
      apiCallSuccess = widget.isSuccessCase;
    } catch (e) {
      debugPrint("Scan log API failed: $e");
      apiCallSuccess = false;
    }

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => ResultScreen(
                isSuccess: apiCallSuccess,
                onItemTapped: widget.onItemTapped,
              ),
        ),
      );
    }
  }

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
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start, // 변경
                      children: [
                        const SizedBox(height: 250),

                        const CircularProgressIndicator(color: Colors.black),
                        const SizedBox(height: 24),
                        const Text(
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
