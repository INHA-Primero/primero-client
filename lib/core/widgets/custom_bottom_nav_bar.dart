// lib/core/widgets/custom_bottom_nav_bar.dart

import 'package:flutter/material.dart';
import 'package:primero/core/theme/app_colors.dart';

class CustomBottomAppBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomAppBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  Widget _buildTabItem({
    required IconData icon,
    required String text,
    required int index,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    final color = isSelected ? AppColors.primary : Colors.grey[600];
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 2),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.0,
      color: Colors.white,
      elevation: 0,
      child: Container(
        // ✨ 하단 바의 높이를 60에서 50으로 줄여 더 슬림하게 만듭니다.
        height: 50,
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey[300]!, width: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildTabItem(
              icon: Icons.home,
              text: '홈',
              index: 0,
              isSelected: selectedIndex == 0,
              onPressed: () => onItemTapped(0),
            ),
            const Expanded(child: SizedBox()),
            _buildTabItem(
              icon: Icons.person,
              text: '내 정보',
              index: 2,
              isSelected: selectedIndex == 2,
              onPressed: () => onItemTapped(2),
            ),
          ],
        ),
      ),
    );
  }
}
