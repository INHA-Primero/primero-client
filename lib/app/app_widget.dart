// --- lib/app/app_widget.dart ---
// 기존의 테마 설정은 100% 유지하고, 라우팅 방식만 수정했습니다.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primero/app/app_router.dart'; // 우리가 만든 AppRouter
import 'package:primero/core/theme/app_colors.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // go_router 대신, 우리가 만든 AppRouter를 직접 home으로 사용합니다.
    return MaterialApp(
      title: 'INHArit',
      theme: ThemeData(
        fontFamily: 'RedHatDisplay',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          surfaceTintColor: Colors.transparent,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      // routerConfig 대신 home 프로퍼티를 사용합니다.
      home: const AppRouter(),
      debugShowCheckedModeBanner: false,
    );
  }
}
