import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_flow/views/screens/bottom_nav_screen.dart';
import 'package:focus_flow/views/screens/home_screen.dart';

import 'core/constants/appTheme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
      const ProviderScope
        (
          child:  MyApp()
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Focus Flow",
      debugShowCheckedModeBanner: false,
      theme: appTheme.DarkTheme,
      home: const BottomNavScreen(),

    );
  }
}

