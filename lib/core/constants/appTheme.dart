import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class appTheme {
  static ThemeData DarkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.primarybg,
    primaryColor: AppColors.main_purple,

    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: AppColors.white,
      displayColor: AppColors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primarybg,
      elevation: 0,
    ),

    // Card
    cardTheme: const CardThemeData(color: AppColors.cardbg),

    // Bottom
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.bottomNavBar,
      selectedItemColor: AppColors.main_purple,
      unselectedItemColor: AppColors.grey_text,
    ),

    // Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.main_purple,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),

    colorScheme: const ColorScheme.dark(
      primary: AppColors.main_purple,
      secondary: AppColors.light_purple,
      surface: AppColors.cardbg,
    ),
  );
}
