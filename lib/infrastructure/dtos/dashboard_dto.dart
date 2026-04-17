// esta clase nos da el marco para tener organizada la informacion historica de cada objetivo
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
