// lib/core/widgets/main_scaffold.dart

import 'package:flutter/material.dart';
import 'package:primero/core/theme/app_colors.dart';
import '../../features/home/home_screen.dart';
import '../../features/profile/ui/screens/profile_screen.dart';
import '../../features/scan/ui/scan_screen.dart';
import 'custom_bottom_nav_bar.dart';

class _CustomFabLocation extends FloatingActionButtonLocation {
  const _CustomFabLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final Offset fabOffset = FloatingActionButtonLocation.centerDocked
        .getOffset(scaffoldGeometry);
    const double verticalAdjustment = 28.0;
    return Offset(fabOffset.dx, fabOffset.dy + verticalAdjustment);
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = [
      const HomeScreen(),
      const SizedBox.shrink(),
      const ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      // 스캔 버튼을 누르면 ScanScreen을 새로운 페이지로 띄웁니다.
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ScanScreen(onItemTapped: _onItemTapped),
        ),
      );
      return; // setState를 호출하지 않고 함수 종료
    }
    // 다른 탭(홈, 내 정보)은 상태를 변경하여 IndexedStack의 화면을 바꿉니다.
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(index: _selectedIndex, children: _widgetOptions),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          onPressed: () => _onItemTapped(1),
          backgroundColor: Colors.white,
          elevation: 2.0,
          shape: const CircleBorder(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/scan_icon.png',
                width: 28,
                height: 28,
                color: Colors.black, // 스캔 버튼은 항상 같은 색으로
              ),
              const SizedBox(height: 4),
              const Text(
                '스캔',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: const _CustomFabLocation(),
      bottomNavigationBar: CustomBottomAppBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
