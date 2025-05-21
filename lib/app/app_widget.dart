// lib/app/app_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:primero/app/app_router.dart'; // goRouterProvider
import 'package:primero/core/theme/app_colors.dart'; // AppColors.primary 사용 위함

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'INHArit',
      theme: ThemeData(
        fontFamily: 'RedHatDisplay',
        useMaterial3: true,
        // ColorScheme을 앱의 주요 색상(AppColors.primary) 기반으로 설정합니다.
        // 이렇게 하면 TextFormField의 포커스 색상, 버튼 색상 등 많은 UI 요소가
        // 일관되게 primary 색상을 따르게 됩니다.
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          // 필요에 따라 밝기(brightness)나 다른 색상 속성을 오버라이드 할 수 있습니다.
          // brightness: Brightness.light,
        ),
        // 만약 InputDecorationTheme을 더 세밀하게 제어하고 싶다면 아래와 같이 설정 가능합니다.
        // inputDecorationTheme: InputDecorationTheme(
        //   focusedBorder: OutlineInputBorder(
        //     borderSide: BorderSide(color: AppColors.primary, width: 2.0),
        //     borderRadius: BorderRadius.circular(10.0),
        //   ),
        //   floatingLabelStyle: const TextStyle(color: AppColors.primary), // 포커스 시 레이블 색상
        //   // 활성화된 (포커스되지 않은) 상태의 테두리 색상 등도 여기서 설정 가능
        //   enabledBorder: OutlineInputBorder(
        //     borderSide: BorderSide(color: Colors.grey.shade400),
        //      borderRadius: BorderRadius.circular(10.0),
        //   ),
        //   // 아이콘 색상도 상태에 따라 변경 가능
        //   prefixIconColor: MaterialStateColor.resolveWith((states) {
        //     if (states.contains(MaterialState.focused)) {
        //       return AppColors.primary;
        //     }
        //     if (states.contains(MaterialState.error)) {
        //       return Theme.of(context).colorScheme.error;
        //     }
        //     return Colors.grey.shade600;
        //   }),
        // ),
        appBarTheme: const AppBarTheme(
          // AppBar 테마 통일성 (선택 사항)
          elevation: 0, // 그림자 제거
          backgroundColor: Colors.white, // 기본 AppBar 배경색
          foregroundColor: Colors.black, // 기본 AppBar 아이콘/텍스트 색상
          surfaceTintColor: Colors.transparent, // 스크롤 시 색상 변경 방지
        ),
        scaffoldBackgroundColor: Colors.white, // 기본 Scaffold 배경색
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
