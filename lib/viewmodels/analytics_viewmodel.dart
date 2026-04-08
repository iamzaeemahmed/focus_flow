import 'package:flutter_riverpod/legacy.dart';

class WeeklyData {
  final String day;
  final double hours;
  WeeklyData({required this.day, required this.hours});
}

final totalFocusTimeProvider = StateProvider<String>((ref) => '37h 12m');
final currentStreakProvider = StateProvider<int>((ref) => 7);
final totalSessionsProvider = StateProvider<int>((ref) => 42);
final weeklyChangeProvider = StateProvider<String>((ref) => '+12%');

final weeklyDataProvider = StateProvider<List<WeeklyData>>((ref) => [
  WeeklyData(day: 'Mon', hours: 3.5),
  WeeklyData(day: 'Tue', hours: 2.0),
  WeeklyData(day: 'Wed', hours: 4.5),
  WeeklyData(day: 'Thu', hours: 3.0),
  WeeklyData(day: 'Fri', hours: 5.0),
  WeeklyData(day: 'Sat', hours: 6.5),
  WeeklyData(day: 'Sun', hours: 4.0),
]);