// import 'package:flutter/material.dart';

// import 'package:primero/core/theme/app_text_style.dart';

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'INHArit',
//       theme: ThemeData(fontFamily: 'RedHatDisplay', useMaterial3: true),
//       home: const _DemoScreen(),
//     );
//   }
// }

// /// 데모: AppTextStyle 을 직접 쓰는 화면
// class _DemoScreen extends StatelessWidget {
//   const _DemoScreen();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: const [
//             Text('Regular 텍스트', style: AppTextStyle.regular),
//             SizedBox(height: 8),
//             Text('Medium 텍스트', style: AppTextStyle.medium),
//             SizedBox(height: 8),
//             Text('SemiBold 텍스트', style: AppTextStyle.semiBold),
//             SizedBox(height: 8),
//             Text('Bold 텍스트', style: AppTextStyle.bold),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'routes/app_router.dart'; // 위에서 만든 라우터
import 'core/theme/app_colors.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'INHArit',
      theme: ThemeData(
        fontFamily: 'RedHatDisplay',
        useMaterial3: true,
        // (원한다면 여기서 ColorScheme.fromSeed 등도 같이 설정)
      ),
      routerConfig: appRouter, // ← 이 한 줄이 GoRouter 를 붙이는 핵심
    );
  }
}
