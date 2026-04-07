import 'package:flutter_riverpod/legacy.dart';

// Selected mode provider (0 = Deep Work, 1 = Light Focus)
final selectedModeProvider = StateProvider<int>((ref) => 0);

// Today focus time provider
final todayFocusTimeProvider = StateProvider<String>((ref) => '2h 34m');

// Sessions provider
final sessionsProvider = StateProvider<int>((ref) => 5);

// Streak provider
final streakProvider = StateProvider<int>((ref) => 7);