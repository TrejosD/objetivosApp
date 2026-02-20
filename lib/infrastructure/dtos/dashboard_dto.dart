import 'package:isar/isar.dart';
import 'package:objetivos/data/db/isar_service.dart';
import 'package:objetivos/data/entities/entities.dart';
import 'package:objetivos/data/entities/goal.dart';
import 'package:objetivos/presentations/providers/goal_streak_provider.dart';

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
