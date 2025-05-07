import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      height: 60,
      backgroundColor: Colors.white,
      elevation: 4,
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      indicatorColor: Colors.transparent,
      destinations: [
        NavigationDestination(
          icon: Icon(
            Icons.home_outlined,
            size: 30,
            color: Colors.grey.shade400,
          ),
          selectedIcon: Icon(Icons.home, size: 30, color: Colors.black),
          label: '',
        ),

        // ★ QR 아이콘은 icon, selectedIcon을 똑같이 녹색 배경으로 고정
        NavigationDestination(
          icon: _buildCenter(),
          selectedIcon: _buildCenter(),
          label: '',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.person_outline,
            size: 30,
            color: Colors.grey.shade400,
          ),
          selectedIcon: Icon(Icons.person, size: 30, color: Colors.black),
          label: '',
        ),
      ],
    );
  }

  /// 항상 녹색 배경 + 흰색 QR 아이콘
  Widget _buildCenter() {
    return Container(
      width: 56,
      height: 56,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.qr_code_scanner, size: 32, color: Colors.white),
    );
  }
}
