// import 'package:flutter/material.dart';
// import 'custom_bottom_nav_bar.dart';
// import 'package:go_router/go_router.dart';

// class MainScaffold extends StatefulWidget {
//   final Widget child;
//   const MainScaffold({required this.child, super.key});

//   @override
//   State<MainScaffold> createState() => _MainScaffoldState();
// }

// class _MainScaffoldState extends State<MainScaffold> {
//   int _selectedIndex = 0;
//   static const _paths = ['/home', '/scan', '/profile'];

//   void _onTap(int idx) {
//     if (idx == _selectedIndex) return;
//     setState(() => _selectedIndex = idx);
//     context.go(_paths[idx]);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: widget.child,
//       bottomNavigationBar: CustomBottomNavBar(
//         currentIndex: _selectedIndex,
//         onTap: _onTap,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'custom_bottom_nav_bar.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatefulWidget {
  final Widget child;
  const MainScaffold({required this.child, super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;
  static const _paths = ['/home', '/scan', '/profile'];

  void _onTap(int idx) {
    if (idx == _selectedIndex) return;
    setState(() => _selectedIndex = idx);
    context.go(_paths[idx]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onTap,
      ),
    );
  }
}
