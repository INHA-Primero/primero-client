// lib/core/widgets/custom_bottom_nav_bar.dart

import 'package:flutter/material.dart';
import 'package:primero/core/theme/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
        BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: '스캔'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: '내 정보'),
      ],
      currentIndex: currentIndex,
      // --- ✨ [수정] 선택된 아이템 색상을 primary 색상으로 변경 ---
      selectedItemColor: AppColors.primary,
      onTap: onTap,
      // 아이템이 선택되지 않았을 때의 색상도 지정해주면 더 좋습니다.
      unselectedItemColor: Colors.grey,
      // 라벨 스타일을 지정하여 일관성을 높일 수 있습니다.
      selectedLabelStyle: const TextStyle(fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      // 배경색을 명시적으로 지정할 수 있습니다.
      backgroundColor: Colors.white,
      // 아이템이 4개 이상일 때의 레이아웃 문제를 방지합니다.
      type: BottomNavigationBarType.fixed,
      elevation: 5,
    );
  }
}
