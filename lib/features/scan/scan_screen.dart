import 'package:flutter/material.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar를 빼면 상단 상태바 바로 아래부터 시작합니다
      body: Center(child: Text('🔍 스캔 화면', style: TextStyle(fontSize: 24))),
    );
  }
}
