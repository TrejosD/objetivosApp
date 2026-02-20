import 'package:isar/isar.dart';
import 'package:objetivos/data/db/isar_service.dart';
import 'package:objetivos/data/entities/goal.dart';
import 'package:objetivos/data/entities/goal_history.dart';
import 'package:objetivos/data/entities/goal_montly.dart';

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

  Future<void> setBetterStreak(int goalId, int currentStreak) async {
    final goal = await isar.goals.get(goalId);
    final now = DateTime.now();
    final monthly = await isar.goalMontlys
        .filter()
        .yearEqualTo(now.year)
        .and()
        .monthEqualTo(now.month)
        .and()
        .goal((q) => q.idEqualTo(goal!.id))
        .findFirst();
    if (goal == null || monthly == null) return;
    if (currentStreak > goal.bestStreak) {
      goal.bestStreak = currentStreak;
    }
    await isar.writeTxn(() async {
      await isar.goals.put(goal);
      await isar.goalMontlys.put(monthly);
    });
  }

  Stream<List<Goal>> watchGoals() {
    return isar.goals.where().watch(fireImmediately: true);
  }

  Future<void> saveGoalHistory(GoalMontly goal, int delta) async {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    final exist = await isar.goalHistorys
        .filter()
        .goalIdEqualTo(goal.id)
        .and()
        .dateEqualTo(today)
        .findFirst();

    await isar.writeTxn(() async {
      if (exist != null) {
        exist.progress = goal.progress;
        exist.delta += delta;
        await isar.goalHistorys.put(exist);
      } else {
        final history = GoalHistory()
          ..goalId = goal.id
          ..progress = goal.progress
          ..delta = delta
          ..date = today;
        await isar.goalHistorys.put(history);
      }
    });
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
    setBetterStreak(history.first.goalId, streak);
    return streak;
  }
}
