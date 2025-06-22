import 'package:flutter/material.dart';
import 'package:primero/features/home/ui/screens/home_screen.dart';
import 'package:primero/features/profile/ui/screens/profile_screen.dart';
import 'package:primero/features/scan/ui/scan_screen.dart';
import 'custom_bottom_nav_bar.dart';

class _CustomFabLocation extends FloatingActionButtonLocation {
  const _CustomFabLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabX =
        (scaffoldGeometry.scaffoldSize.width -
            scaffoldGeometry.floatingActionButtonSize.width) /
        2;
    final double fabY =
        scaffoldGeometry.scaffoldSize.height -
        scaffoldGeometry.bottomSheetSize.height -
        scaffoldGeometry.floatingActionButtonSize.height -
        30;

    return Offset(fabX, fabY);
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
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ScanScreen(onItemTapped: _onItemTapped),
        ),
      );
      return;
    }
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
                color: Colors.black,
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
