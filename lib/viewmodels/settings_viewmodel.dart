import 'package:flutter_riverpod/legacy.dart';

final focusDurationProvider = StateProvider<int>((ref) => 25);
final pushNotificationsProvider = StateProvider<bool>((ref) => true);
final soundEffectsProvider = StateProvider<bool>((ref) => true);
final hapticFeedbackProvider = StateProvider<bool>((ref) => true);
final darkModeProvider = StateProvider<bool>((ref) => true);
final showStreakProvider = StateProvider<bool>((ref) => true);