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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!, width: 0.5)),
      ),
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.transparent,
        surfaceTintColor: Colors.white,
        elevation: 0,
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
