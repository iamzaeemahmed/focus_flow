import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// Timer value provider
final focusTimerProvider = StateProvider<int>((ref) => 1500);

// Is running provider
final isTimerRunningProvider = StateProvider<bool>((ref) => false);

final isFocusFullScreenProvider = StateProvider<bool>((ref) => false);


// Timer Notifier
class FocusTimerNotifier extends Notifier<int> {
  Timer? _timer;

  @override
  int build() => 1500;

  void start() {
    ref.read(isTimerRunningProvider.notifier).state = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state > 0) {
        state--;
        ref.read(focusTimerProvider.notifier).state = state;
      } else {
        _timer?.cancel();
        ref.read(isTimerRunningProvider.notifier).state = false;
      }
    });
  }

  void pause() {
    _timer?.cancel();
    ref.read(isTimerRunningProvider.notifier).state = false;
  }

  void reset() {
    _timer?.cancel();
    state = 1500;
    ref.read(focusTimerProvider.notifier).state = 1500;
    ref.read(isTimerRunningProvider.notifier).state = false;
  }
}

final focusTimerNotifierProvider =
NotifierProvider<FocusTimerNotifier, int>(FocusTimerNotifier.new);