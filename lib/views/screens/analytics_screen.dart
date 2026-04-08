import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/strings.dart';
import '../../viewmodels/analytics_viewmodel.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalTime = ref.watch(totalFocusTimeProvider);
    final streak = ref.watch(currentStreakProvider);
    final sessions = ref.watch(totalSessionsProvider);
    final weeklyChange = ref.watch(weeklyChangeProvider);
    final weeklyData = ref.watch(weeklyDataProvider);

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
              const SizedBox(height: 20),

              // Stat Cards
              _buildStatCard(
                icon: Iconsax.clock,
                title: AppStrings.totalFocusTime,
                value: totalTime,
                change: weeklyChange,
                changePositive: true,
              ),
              const SizedBox(height: 10),
              _buildStatCard(
                icon: Iconsax.flash,
                title: AppStrings.currentStreak,
                value: '$streak Days',
                change: '+2',
                changePositive: true,
              ),
              const SizedBox(height: 10),
              _buildStatCard(
                icon: Iconsax.activity,
                title: AppStrings.sessions,
                value: sessions.toString(),
                change: '+8',
                changePositive: true,
              ),
              const SizedBox(height: 24),

              // Weekly Chart
              _buildWeeklyChart(weeklyData),
              const SizedBox(height: 24),

              // Focus Distribution
              _buildFocusDistribution(),
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
          AppStrings.analytics,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        Text(
          AppStrings.analyticsSubtitle,
          style: TextStyle(
            fontSize: 13,
            color: AppColors.grey_text,
          ),
        ),
      ],
    );
  }

  // ── Stat Card ────────────────────────────
  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required String change,
    required bool changePositive,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardbg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.card_border, width: 0.5),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.main_purple.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.main_purple, size: 20),
          ),
          const SizedBox(width: 14),

          // Title & Value
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.grey_text,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),

          // Change Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.success_green.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              change,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: changePositive
                    ? AppColors.success_green
                    : Colors.redAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Weekly Chart ─────────────────────────
  Widget _buildWeeklyChart(List<WeeklyData> weeklyData) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardbg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.card_border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.weeklyFocusHours,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 8,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: 2,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.grey_text,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            weeklyData[value.toInt()].day,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.grey_text,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.card_border,
                    strokeWidth: 0.5,
                  ),
                  drawVerticalLine: false,
                ),
                borderData: FlBorderData(show: false),
                barGroups: weeklyData.asMap().entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value.hours,
                        color: AppColors.main_purple,
                        width: 22,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 8,
                          color: AppColors.main_purple.withOpacity(0.08),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Focus Distribution ───────────────────
  Widget _buildFocusDistribution() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardbg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.card_border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.focusDistribution,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Pie Chart
              SizedBox(
                width: 120,
                height: 120,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 30,
                    sections: [
                      PieChartSectionData(
                        value: 60,
                        color: AppColors.main_purple,
                        radius: 30,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        value: 25,
                        color: AppColors.dark_purple,
                        radius: 30,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        value: 15,
                        color: AppColors.card_border,
                        radius: 30,
                        showTitle: false,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),

              // Legend
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _legendItem(AppColors.main_purple, 'Deep Work', '60%'),
                    const SizedBox(height: 10),
                    _legendItem(AppColors.dark_purple, 'Light Focus', '25%'),
                    const SizedBox(height: 10),
                    _legendItem(AppColors.card_border, 'Breaks', '15%'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label, String percent) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.grey_text,
            ),
          ),
        ),
        Text(
          percent,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }
}