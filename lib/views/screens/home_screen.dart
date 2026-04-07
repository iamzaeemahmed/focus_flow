import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focus_flow/core/constants/colors.dart';
import 'package:focus_flow/viewmodels/home_screen_viewmodel.dart';
import 'package:iconsax/iconsax.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../core/constants/strings.dart';
import '../../viewmodels/focus_viewmodel.dart';
import 'focus_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMode = ref.watch(selectedModeProvider);
    final todayTime = ref.watch(todayFocusTimeProvider);
    final sessions = ref.watch(sessionsProvider);
    final streak = ref.watch(streakProvider);

    return Scaffold(
      backgroundColor: AppColors.primarybg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // top title
              _buildHeader(),
              const SizedBox(height: 20),

              // Stats Row
              _buildStatsRow(todayTime, sessions, streak),
              const SizedBox(height: 30),

              // Timer Circle
              _buildTimerCircle(ref, selectedMode),
              const SizedBox(height: 30),

              // Mode Selector
              _buildModeSelector(ref, selectedMode),
              const SizedBox(height: 20),

              // Start Button
              _buildStartButton(context, ref),
              const SizedBox(height: 12),

              // Full Focus Mode Button
              _buildFullFocusButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Focus Timer",
          style: TextStyle(
            color: AppColors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),

        Text(
          "Stay focused, stay productive",
          style: TextStyle(color: AppColors.grey_text, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildStatsRow(String todayTime, int sessions, int streak) {
    return Row(
      children: [
        _statCard(Iconsax.clock, todayTime, AppStrings.today),
        const SizedBox(width: 10),
        _statCard(Iconsax.activity, sessions.toString(), AppStrings.sessions),
        const SizedBox(width: 10),
        _statCard(Iconsax.flash, streak.toString(), AppStrings.dayStreak),
      ],
    );
  }

  Widget _statCard(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.card_border,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.card_border, width: 10),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.main_purple, size: 18),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 9, color: AppColors.grey_text),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerCircle(WidgetRef ref, int selectedMode) {
    final timerValue = ref.watch(focusTimerProvider);
    final minutes = (timerValue ~/ 60).toString().padLeft(2, '0');
    final seconds = (timerValue % 60).toString().padLeft(2, '0');
    final totalTime = selectedMode == 0 ? 1500 : 900;
    final percent = (timerValue / totalTime).clamp(0.0, 1.0);

    return Center(
      child: CircularPercentIndicator(
        radius: 120,
        lineWidth: 8,
        percent: percent,
        backgroundColor: AppColors.cardbg,
        progressColor: AppColors.main_purple,
        circularStrokeCap: CircularStrokeCap.round,
        center: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$minutes:$seconds',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w300,
                color: AppColors.white,
                letterSpacing: 2,
              ),
            ),
            Text(
              selectedMode == 0 ? AppStrings.deepWork : AppStrings.lightFocus,
              style: const TextStyle(fontSize: 12, color: AppColors.grey_text),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeSelector(WidgetRef ref, int selectedMode) {
    return Row(
      children: [
        _modeButton(ref, 0, selectedMode, AppStrings.deepWork, '25 min'),
        const SizedBox(width: 12),
        _modeButton(ref, 1, selectedMode, AppStrings.lightFocus, '15 min'),
      ],
    );
  }

  Widget _modeButton(
    WidgetRef ref,
    int index,
    int selectedMode,
    String title,
    String subtitle,
  ) {
    final isSelected = selectedMode == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(selectedModeProvider.notifier).state = index;
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.main_purple : AppColors.cardbg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppColors.main_purple : AppColors.card_border,
              width: 0.5,
            ),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.white : AppColors.grey_text,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected
                      ? AppColors.white.withOpacity(0.7)
                      : AppColors.subtitle_Grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Start Button ─────────────────────────
  Widget _buildStartButton(BuildContext context, WidgetRef ref) {
    final isRunning = ref.watch(isTimerRunningProvider);

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (isRunning) {
                ref.read(focusTimerNotifierProvider.notifier).pause();
              } else {
                ref.read(focusTimerNotifierProvider.notifier).start();
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.main_purple,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isRunning ? Iconsax.pause : Iconsax.play,
                    color: AppColors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isRunning ? 'Pause' : AppStrings.startFocus,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Reset Button
        GestureDetector(
          onTap: () {
            ref.read(focusTimerNotifierProvider.notifier).reset();
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardbg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.card_border, width: 0.5),
            ),
            child: const Icon(
              Iconsax.refresh,
              color: AppColors.grey_text,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }

  // ── Full Focus Button ─────────────────────
  Widget _buildFullFocusButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => const FocusScreen(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.main_purple, width: 0.5),
        ),
        child: const Center(
          child: Text(
            AppStrings.enterFullFocusMode,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.main_purple,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
