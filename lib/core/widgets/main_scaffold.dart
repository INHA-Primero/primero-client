import 'package:flutter/material.dart';
import '../../features/home/home_screen.dart';
import '../../features/profile/ui/screens/profile_screen.dart';
import '../../features/scan/ui/scan_screen.dart';
import 'custom_bottom_nav_bar.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // ✨ виджет 목록을 build 메서드 안으로 이동하여 함수를 전달합니다.
  List<Widget> _buildWidgetOptions() {
    return [
      const HomeScreen(),
      ScanScreen(onItemTapped: _onItemTapped), // ✨ 스캔 화면에 탭 이동 함수 전달
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✨ IndexedStack의 children을 함수 호출로 변경
      body: IndexedStack(
        index: _selectedIndex,
        children: _buildWidgetOptions(),
      ),
      // ✨ _selectedIndex가 1(스캔 탭)일 경우 하단 네비게이션 바를 숨김
      bottomNavigationBar:
          _selectedIndex == 1
              ? null
              : CustomBottomNavBar(
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
              ),
    );
  }
}
