// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ProviderScope를 위해 임포트
import 'package:primero/app/app_widget.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized(); // 필요하다면 (예: Firebase 초기화 등)

  runApp(
    // ProviderScope로 앱의 루트 위젯을 감싸줍니다.
    // 이렇게 하면 앱 전체에서 Riverpod Provider들을 사용할 수 있게 됩니다.
    const ProviderScope(
      child: MyApp(), // MyApp은 app_widget.dart 안에 정의된 위젯
    ),
  );
}
