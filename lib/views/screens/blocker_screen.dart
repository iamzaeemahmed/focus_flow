import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/strings.dart';
import '../../data/model/app_block_model.dart';
import '../../viewmodels/blocker_viewmodel.dart';

class BlockerScreen extends ConsumerWidget {
  const BlockerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apps = ref.watch(appsListProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final blockedCount = ref.read(appsListProvider.notifier).blockedCount;

    final filteredApps = apps
        .where((app) => app.category == selectedCategory)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.primarybg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),
              const SizedBox(height: 20),

              // Blocked Count Card
              _buildBlockedCard(blockedCount),
              const SizedBox(height: 20),

              // Category Pills
              _buildCategoryPills(ref, selectedCategory),
              const SizedBox(height: 16),

              // Apps List
              Expanded(
                child: ListView.builder(
                  itemCount: filteredApps.length,
                  itemBuilder: (context, index) {
                    return _buildAppTile(ref, filteredApps[index]);
                  },
                ),
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
          AppStrings.appBlocker,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        Text(
          AppStrings.blockSubtitle,
          style: TextStyle(
            fontSize: 13,
            color: AppColors.grey_text,
          ),
        ),
      ],
    );
  }

  // ── Blocked Count Card ───────────────────
  Widget _buildBlockedCard(int blockedCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardbg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.card_border, width: 0.5),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                AppStrings.appsBlocked,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.grey_text,
                ),
              ),
              Text(
                blockedCount.toString(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.main_purple.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Iconsax.shield_tick,
              color: AppColors.main_purple,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  // ── Category Pills ───────────────────────
  Widget _buildCategoryPills(WidgetRef ref, String selectedCategory) {
    final categories = ['SOCIAL', 'ENTERTAINMENT', 'GAMES'];
    return Row(
      children: categories.map((category) {
        final isSelected = selectedCategory == category;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () {
              ref.read(selectedCategoryProvider.notifier).state = category;
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.main_purple
                    : AppColors.cardbg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.main_purple
                      : AppColors.card_border,
                  width: 0.5,
                ),
              ),
              child: Text(
                category,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? AppColors.white : AppColors.grey_text,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── App Tile ─────────────────────────────
  Widget _buildAppTile(WidgetRef ref, AppBlockModel app) {
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
          // App Icon
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.main_purple.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Iconsax.mobile,
              color: AppColors.main_purple,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // App Name & Status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  app.appName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ),
                Text(
                  app.isBlocked ? AppStrings.blocked : AppStrings.active,
                  style: TextStyle(
                    fontSize: 11,
                    color: app.isBlocked
                        ? AppColors.main_purple
                        : AppColors.grey_text,
                  ),
                ),
              ],
            ),
          ),

          // Toggle
          Switch(
            value: app.isBlocked,
            onChanged: (value) {
              ref.read(appsListProvider.notifier).toggleApp(app.packageName);
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
}