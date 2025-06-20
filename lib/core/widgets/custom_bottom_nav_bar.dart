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
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✨ [UI 수정] Container로 감싸서 위쪽 테두리(구분선) 추가
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // 배경색을 흰색으로 지정해야 그림자 위에 선이 잘 보입니다.
        border: Border(top: BorderSide(color: Colors.grey[300]!, width: 0.5)),
      ),
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.transparent, // Container에서 색상을 관리하므로 투명하게 변경
        surfaceTintColor: Colors.white,
        elevation: 0, // Container에서 그림자를 관리할 수 있으므로 0으로 설정
        padding: EdgeInsets.zero,
        height: 60,
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
