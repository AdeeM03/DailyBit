import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '../services/sync_service.dart';
import 'views/home_view.dart';
import 'views/diary_view.dart';
import 'views/history_view.dart';
import 'views/me_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  @override
  void initState() {
    super.initState();
    SyncService.instance.syncInBackground();
  }

  static const _activeColor = Color(0xFF58CC02); // Duolingo Green
  static const _inactiveColor = Color(0xFFBDBDBD);

  List<Widget> _buildScreens() => [
        const HomeView(),
        const DiaryView(),
        const HistoryView(),
        const MeView(),
      ];

  List<PersistentBottomNavBarItem> _navItems() => [
        PersistentBottomNavBarItem(
          icon: SvgPicture.asset('assets/icons/nav_habit_active.svg', width: 30, height: 30),
          inactiveIcon: SvgPicture.asset('assets/icons/nav_habit_inactive.svg', width: 30, height: 30),
          title: 'Habbit',
          activeColorPrimary: _activeColor,
          inactiveColorPrimary: _inactiveColor,
        ),
        PersistentBottomNavBarItem(
          icon: SvgPicture.asset('assets/icons/nav_diary_active.svg', width: 30, height: 30),
          inactiveIcon: SvgPicture.asset('assets/icons/nav_diary_inactive.svg', width: 30, height: 30),
          title: 'Diary',
          activeColorPrimary: _activeColor,
          inactiveColorPrimary: _inactiveColor,
        ),
        PersistentBottomNavBarItem(
          icon: SvgPicture.asset('assets/icons/nav_history_active.svg', width: 30, height: 30),
          inactiveIcon: SvgPicture.asset('assets/icons/nav_history_inactive.svg', width: 30, height: 30),
          title: 'History',
          activeColorPrimary: _activeColor,
          inactiveColorPrimary: _inactiveColor,
        ),
        PersistentBottomNavBarItem(
          icon: SvgPicture.asset('assets/icons/nav_me_active.svg', width: 30, height: 30),
          inactiveIcon: SvgPicture.asset('assets/icons/nav_me_inactive.svg', width: 30, height: 30),
          title: 'Me',
          activeColorPrimary: _activeColor,
          inactiveColorPrimary: _inactiveColor,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navItems(),
      backgroundColor: Colors.white,
      navBarStyle: NavBarStyle.style13,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardAppears: true,
      confineToSafeArea: true,
    );
  }
}
