class GoalStats {
  final int currentStreak;
  final int bestStreak;
  final int activeDays;
  final double completionRate;
  final double dailyAverage;

  GoalStats({
    required this.currentStreak,
    required this.bestStreak,
    required this.activeDays,
    required this.completionRate,
    required this.dailyAverage,
  });
}
