import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/strings.dart';
import '../../viewmodels/settings_viewmodel.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pushNotifications = ref.watch(pushNotificationsProvider);
    final soundEffects = ref.watch(soundEffectsProvider);
    final hapticFeedback = ref.watch(hapticFeedbackProvider);
    final darkMode = ref.watch(darkModeProvider);
    final showStreak = ref.watch(showStreakProvider);
    final focusDuration = ref.watch(focusDurationProvider);

    return Scaffold(
      backgroundColor: AppColors.primarybg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),
              const SizedBox(height: 24),

              // Focus Duration Section
              _buildSectionTitle(AppStrings.focusDuration),
              const SizedBox(height: 12),
              _buildDurationSelector(ref, focusDuration),
              const SizedBox(height: 24),

              // Notifications Section
              _buildSectionTitle(AppStrings.notifications),
              const SizedBox(height: 12),
              _buildToggleTile(
                ref: ref,
                icon: Iconsax.notification,
                iconBg: const Color(0xFF1A1040),
                title: AppStrings.pushNotifications,
                subtitle: 'Get reminded to focus',
                value: pushNotifications,
                provider: pushNotificationsProvider,
              ),
              _buildToggleTile(
                ref: ref,
                icon: Iconsax.volume_high,
                iconBg: const Color(0xFF0D2010),
                title: AppStrings.soundEffects,
                subtitle: 'Play sounds during sessions',
                value: soundEffects,
                provider: soundEffectsProvider,
              ),
              _buildToggleTile(
                ref: ref,
                icon: Iconsax.mobile,
                iconBg: const Color(0xFF1A1040),
                title: AppStrings.hapticFeedback,
                subtitle: 'Vibrate on interactions',
                value: hapticFeedback,
                provider: hapticFeedbackProvider,
              ),
              const SizedBox(height: 24),

              // Appearance Section
              _buildSectionTitle(AppStrings.appearance),
              const SizedBox(height: 12),
              _buildToggleTile(
                ref: ref,
                icon: Iconsax.moon,
                iconBg: const Color(0xFF0D1020),
                title: AppStrings.darkMode,
                subtitle: 'Reduce eye strain',
                value: darkMode,
                provider: darkModeProvider,
              ),
              const SizedBox(height: 24),

              // Focus Settings Section
              _buildSectionTitle('FOCUS SETTINGS'),
              const SizedBox(height: 12),
              _buildToggleTile(
                ref: ref,
                icon: Iconsax.flash,
                iconBg: const Color(0xFF1A1040),
                title: AppStrings.showStreak,
                subtitle: 'Show streak on home screen',
                value: showStreak,
                provider: showStreakProvider,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Header ───────────────────────────────
  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.settingsTitle,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        Text(
          AppStrings.settingsSubtitle,
          style: TextStyle(
            fontSize: 13,
            color: AppColors.grey_text,
          ),
        ),
      ],
    );
  }

  // ── Section Title ────────────────────────
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.grey_text,
        letterSpacing: 0.8,
      ),
    );
  }

  // ── Duration Selector ────────────────────
  Widget _buildDurationSelector(WidgetRef ref, int selected) {
    final durations = [
      {'label': '15 min', 'sub': 'Quick focus', 'value': 15},
      {'label': '25 min', 'sub': 'Pomodoro', 'value': 25},
      {'label': '50 min', 'sub': 'Deep work', 'value': 50},
      {'label': 'Custom', 'sub': 'Set your own', 'value': 0},
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.5,
      children: durations.map((d) {
        final isSelected = selected == d['value'];
        return GestureDetector(
          onTap: () {
            if (d['value'] != 0) {
              ref.read(focusDurationProvider.notifier).state =
              d['value'] as int;
            } else {
              _showCustomDurationDialog(ref);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.main_purple.withOpacity(0.2)
                  : AppColors.cardbg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AppColors.main_purple
                    : AppColors.card_border,
                width: isSelected ? 1 : 0.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  d['label'] as String,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? AppColors.main_purple
                        : AppColors.white,
                  ),
                ),
                Text(
                  d['sub'] as String,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.grey_text,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Toggle Tile ──────────────────────────
  Widget _buildToggleTile({
    required WidgetRef ref,
    required IconData icon,
    required Color iconBg,
    required String title,
    required String subtitle,
    required bool value,
    required StateProvider<bool> provider,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardbg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.card_border, width: 0.5),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.main_purple, size: 18),
          ),
          const SizedBox(width: 12),

          // Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.grey_text,
                  ),
                ),
              ],
            ),
          ),

          // Toggle
          Switch(
            value: value,
            onChanged: (val) {
              ref.read(provider.notifier).state = val;
            },
            activeColor: AppColors.main_purple,
            activeTrackColor: AppColors.main_purple.withOpacity(0.3),
            inactiveThumbColor: AppColors.grey_text,
            inactiveTrackColor: AppColors.card_border,
          ),
        ],
      ),
    );
  }

  // ── Custom Duration Dialog ────────────────
  void _showCustomDurationDialog(WidgetRef ref) {}
}