import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:iconsax/iconsax.dart';

import '../../core/constants/colors.dart';
import '../../viewmodels/bottom_nav_viewmodel.dart';
import '../../viewmodels/focus_viewmodel.dart';
import 'analytics_screen.dart';
import 'blocker_screen.dart';
import 'focus_screen.dart';
import 'home_screen.dart';
import 'setting_screen.dart';

class BottomNavScreen extends ConsumerWidget {
  const BottomNavScreen({super.key});

  static const List<Widget> _screens = [
    HomeScreen(),
    FocusScreen(),
    BlockerScreen(),
    AnalyticsScreen(),
    SettingScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavProvider);
    final isFocusFullScreen = ref.watch(isFocusFullScreenProvider);

    return Scaffold(
      backgroundColor: AppColors.primarybg,
      body: _screens[currentIndex],
      bottomNavigationBar: isFocusFullScreen
        ? null  // hides nav bar
            : Container(
        decoration: BoxDecoration(
          color: AppColors.bottomNavBar,
          border: Border(
            top: BorderSide(
              color: AppColors.card_border,
              width: 0.5,
            )
          )
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
            onTap: (index){
            ref.read(bottomNavProvider.notifier).state = index;
            },

            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.bottomNavBar,
            selectedItemColor: AppColors.main_purple,
            unselectedItemColor: AppColors.grey_text,
            selectedFontSize: 10,
            unselectedFontSize: 10,
            items: const [
        BottomNavigationBarItem(
          icon: Icon(Iconsax.home),
          activeIcon: Icon(Iconsax.home_14),
          label: "Home",
        ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.timer),
            activeIcon: Icon(Iconsax.timer5),
            label: "Focus",
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.shield),
            activeIcon: Icon(Iconsax.shield_tick),
            label: "Blocker",
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.chart),
            activeIcon: Icon(Iconsax.chart_15),
            label: "Stats",
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.setting),
            activeIcon: Icon(Iconsax.setting_2),
            label: "Settings",
          ),
        ]
        ),
      ),

    );
  }
}
