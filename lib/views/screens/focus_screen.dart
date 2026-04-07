import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/strings.dart';
import '../../viewmodels/bottom_nav_viewmodel.dart';
import '../../viewmodels/focus_viewmodel.dart';

class FocusScreen extends ConsumerWidget {
  const FocusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(isFocusFullScreenProvider.notifier).state = true;
    });
    final timerValue = ref.watch(focusTimerProvider);
    final isRunning = ref.watch(isTimerRunningProvider);
    final minutes = (timerValue ~/ 60).toString().padLeft(2, '0');
    final seconds = (timerValue % 60).toString().padLeft(2, '0');

    return Scaffold(
      backgroundColor: AppColors.primarybg,
      body: Stack(
        children: [
          // Main Content
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTimer(minutes, seconds),
                const SizedBox(height: 16),
                const Text(
                  AppStrings.stayFocused,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.grey_text,
                  ),
                ),
                const SizedBox(height: 40),
                _buildBreathingCircle(isRunning),
                const SizedBox(height: 16),
                const Text(
                  AppStrings.breathe,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.subtitle_Grey,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 60),
                _buildControls(ref, isRunning),
              ],
            ),
          ),

          // Close Button on top
          Positioned(
            top: 50,
            right: 16,
            child: GestureDetector(
              onTap: () {
                ref.read(isFocusFullScreenProvider.notifier).state = false;
                ref.read(bottomNavProvider.notifier).state = 0;
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.cardbg,
                  border: Border.all(color: AppColors.card_border, width: 0.5),
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: AppColors.grey_text,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),

    )
    ;
  }

  // ── Timer Display ─────────────────────────
  Widget _buildTimer(String minutes, String seconds) {
    return Text(
      '$minutes:$seconds',
      style: const TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.w200,
        color: AppColors.white,
        letterSpacing: 4,
      ),
    );
  }

  // ── Breathing Circle ──────────────────────
  Widget _buildBreathingCircle(bool isRunning) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.2),
      duration: const Duration(seconds: 4),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: isRunning ? value : 1.0,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.main_purple.withOpacity(0.15),
              border: Border.all(
                color: AppColors.main_purple.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.main_purple,
                ),
              ),
            ),
          ),
        );
      },
      onEnd: () {},
    );
  }

  // ── Controls ──────────────────────────────
  Widget _buildControls(WidgetRef ref, bool isRunning) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Reset
        _controlButton(
          icon: Icons.refresh_rounded,
          onTap: () {
            ref.read(focusTimerNotifierProvider.notifier).reset();
          },
        ),
        const SizedBox(width: 20),

        // Play / Pause
        GestureDetector(
          onTap: () {
            if (isRunning) {
              ref.read(focusTimerNotifierProvider.notifier).pause();
            } else {
              ref.read(focusTimerNotifierProvider.notifier).start();
            }
          },
          child: Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.main_purple,
            ),
            child: Icon(
              isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: AppColors.white,
              size: 32,
            ),
          ),
        ),
        const SizedBox(width: 20),

        // Stop
        _controlButton(
          icon: Icons.stop_rounded,
          onTap: () {
            ref.read(focusTimerNotifierProvider.notifier).reset();
          },
        ),
      ],
    );
  }

  Widget _controlButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.cardbg,
          border: Border.all(color: AppColors.card_border, width: 0.5),
        ),
        child: Icon(
          icon,
          color: AppColors.grey_text,
          size: 22,
        ),
      ),
    );
  }
}