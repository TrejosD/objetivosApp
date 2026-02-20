import 'package:isar/isar.dart';
import 'package:objetivos/data/db/isar_service.dart';
import 'package:objetivos/data/entities/goal.dart';
import 'package:objetivos/data/entities/goal_history.dart';
import 'package:objetivos/data/entities/goal_montly.dart';
import 'package:objetivos/infrastructure/dtos/dashboard_dto.dart';

class GoalRepository {
  final isar = IsarService.isar;

  Future<Goal> createGoal(String name, int target) async {
    final goal = Goal()
      ..name = name
      ..target = target;

    await isar.writeTxn(() async {
      await isar.goals.put(goal);
    });
    return goal;
  }

  Future<void> createMonthlyGoals() async {
    final now = DateTime.now();

    final goals = await isar.goals.where().findAll();

    for (final goal in goals) {
      final exist = await isar.goalMontlys
          .filter()
          .yearEqualTo(now.year)
          .and()
          .monthEqualTo(now.month)
          .and()
          .goal((q) => q.idEqualTo(goal.id))
          .findFirst();
      if (exist == null) {
        final montly = GoalMontly()
          ..year = now.year
          ..month = now.month
          ..target = goal.target
          ..progress = 0
          ..goal.value = goal;
        await isar.writeTxn(() async {
          await isar.goalMontlys.put(montly);
          await montly.goal.save();
        });
      }
    }
  }

  Future<GoalStats> getGoalStats(GoalMontly monthly) async {
    final goal = monthly.goal.value!;
    final now = DateTime.now();
    final currentStreak = await getCurrentStreak(goal.id);
    final completionRate = (monthly.progress / goal.target) * 100;
    final history = await isar.goalHistorys
        .filter()
        .goalIdEqualTo(goal.id)
        .and()
        .dateGreaterThan(DateTime(now.year, now.month, 1))
        .findAll();
    final totalDelta = history.fold<int>(0, (sum, e) => sum + e.delta);
    final activeDays = history.length;
    final double dailyAverage = activeDays == 0 ? 0 : totalDelta / activeDays;

    return GoalStats(
      currentStreak: currentStreak,
      bestStreak: goal.bestStreak,
      activeDays: activeDays,
      completionRate: completionRate,
      dailyAverage: dailyAverage,
    );
  }

  Future<void> updateGoal(Goal goal, String name, int target) async {
    goal
      ..name = name
      ..target = target;
    await isar.writeTxn(() async {
      await isar.goals.put(goal);
      final now = DateTime.now();
      final currentMonthly = await isar.goalMontlys
          .filter()
          .yearEqualTo(now.year)
          .and()
          .monthEqualTo(now.month)
          .and()
          .goal((q) => q.idEqualTo(goal.id))
          .findFirst();
      if (currentMonthly != null) {
        currentMonthly.target = target;
        await isar.goalMontlys.put(currentMonthly);
      }
    });
  }

  Stream<List<Goal>> watchGoals() {
    return isar.goals.where().watch(fireImmediately: true);
  }

  Future<void> saveGoalHistory(int goalId, int progress, int delta) async {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    final exist = await isar.goalHistorys
        .filter()
        .goalIdEqualTo(goalId)
        .and()
        .dateEqualTo(today)
        .findFirst();

    await isar.writeTxn(() async {
      if (exist != null) {
        exist.progress = progress;
        exist.delta += delta;
        await isar.goalHistorys.put(exist);
      } else {
        final history = GoalHistory()
          ..goalId = goalId
          ..progress = progress
          ..delta = delta
          ..date = today;
        await isar.goalHistorys.put(history);
      }
    });
  }

  Future<bool> incrementProgress(GoalMontly monthly, int delta) async {
    bool reached = false;
    await isar.writeTxn(() async {
      monthly.progress += delta;
      if (monthly.progress == monthly.target) {
        monthly.completed = true;
        reached = true;
      }
      await isar.goalMontlys.put(monthly);
      final goal = monthly.goal.value!;
      await saveGoalHistory(goal.id, monthly.progress, delta);
      final currentStreak = await getCurrentStreak(goal.id);
      if (currentStreak > goal.bestStreak) {
        goal.bestStreak = currentStreak;
        await isar.writeTxn(() async {
          await isar.goals.put(goal);
        });
      }
    });
    return reached;
  }

  Future<int> getCurrentStreak(int goalId) async {
    final history = await isar.goalHistorys
        .filter()
        .goalIdEqualTo(goalId)
        .sortByDateDesc()
        .findAll();
    if (history.isEmpty) return 0;
    int streak = 0;
    DateTime now = DateTime.now();
    DateTime expectedDay = DateTime(now.year, now.month, now.day);
    // Comenzar registro desde ayer
    final lastDay = DateTime(
      history.first.date.year,
      history.first.date.month,
      history.first.date.day,
    );
    if (lastDay != expectedDay) {
      expectedDay = expectedDay.subtract(Duration(days: 1));
    }
    for (final entry in history) {
      final entryDay = DateTime(
        entry.date.year,
        entry.date.month,
        entry.date.day,
      );
      if (entryDay == expectedDay) {
        streak++;
        expectedDay = expectedDay.subtract(Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }
}
