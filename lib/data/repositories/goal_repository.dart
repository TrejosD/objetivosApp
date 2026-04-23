import 'package:isar/isar.dart';
import 'package:objetivos/data/db/isar_service.dart';
import 'package:objetivos/data/entities/goal.dart';
import 'package:objetivos/data/entities/goal_history.dart';
import 'package:objetivos/data/entities/goal_montly.dart';
import 'package:objetivos/infrastructure/dtos/dashboard_dto.dart';
import 'package:objetivos/infrastructure/entitites/momentum.dart';

class GoalRepository {
  final isar = IsarService.isar;
  // metodo para crear un nuevo objetivo
  Future<Goal> createGoal(String name, int target) async {
    final goal = Goal()
      ..name = name
      ..target = target;

    await isar.writeTxn(() async {
      await isar.goals.put(goal);
    });
    return goal;
  }

  // metodo permite que los objetivos se reinicien automaticamete cada mes
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

  // metodo para actualizar un objetivo
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

  Future<void> deleteGoal(Goal goal) async {
    await isar.writeTxn(() async {
      // eliminar goalMonthly
      await isar.goalMontlys
          .filter()
          .goal((q) => q.idEqualTo(goal.id))
          .deleteAll();
      // eliminar goalHistory
      await isar.goalHistorys.filter().goalIdEqualTo(goal.id).deleteAll();
      // eliminar goal
      await isar.goals.delete(goal.id);
    });
  }

  // metodo permite llevar un historico del objetivo
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

  // metodo para obtener la racha de cada objetivo
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

  // metodo para obtener las estadisticas de cada objetivo
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

  // metodo para incrementar progreso del objetivo
  Future<bool> incrementProgress(GoalMontly monthly, int delta) async {
    bool reached = false;
    await isar.writeTxn(() async {
      monthly.progress += delta;
      if (monthly.progress == monthly.target) {
        monthly.completed = true;
        reached = true;
      }
      await isar.goalMontlys.put(monthly);
    });
    final goal = monthly.goal.value!;
    final currentStreak = await getCurrentStreak(goal.id);
    await saveGoalHistory(goal.id, monthly.progress, delta);
    if (currentStreak > goal.bestStreak) {
      goal.bestStreak = currentStreak;
      await isar.writeTxn(() async {
        await isar.goals.put(goal);
      });
    }
    return reached;
  }

  // este metodo permite obtener el mes anterior, para el historico, sin errar el cambio de año
  Future<GoalMontly?> getPreviousMonth(GoalMontly current) async {
    int prevMonth = current.month - 1;
    int year = current.year;

    if (prevMonth == 0) {
      prevMonth = 12;
      year--;
    }

    return await isar.goalMontlys
        .filter()
        .goal((q) => q.idEqualTo(current.goal.value!.id))
        .and()
        .yearEqualTo(year)
        .and()
        .monthEqualTo(prevMonth)
        .findFirst();
  }

  // metodo obtiene el promedio diario de progreso
  Future<double> getDailyAverage(int goalId) async {
    final now = DateTime.now();

    final startOfMonth = DateTime(now.year, now.month, 1);
    final history = await isar.goalHistorys
        .filter()
        .goalIdEqualTo(goalId)
        .and()
        .dateGreaterThan(startOfMonth)
        .findAll();

    if (history.isEmpty) return 0;
    final total = history.fold<int>(0, (sum, e) => sum + e.delta);
    return total / history.length;
  }

  // metodo obtiene la racha diaria de uso del app
  Future<int> getActiveDays(int goalId) async {
    final now = DateTime.now();

    final startOfMonth = DateTime(now.year, now.month, 1);

    return await isar.goalHistorys
        .filter()
        .goalIdEqualTo(goalId)
        .and()
        .dateGreaterThan(startOfMonth)
        .count();
  }

  // metodo obtiene el total de dias trabajados en un objetivo
  Future<int> getTotalProgressThisMonth(int goalId) async {
    final now = DateTime.now();
    // todo Revisar donde funciona mejor este metodo, si ACa o en Motivation service
    final startOfMonth = DateTime(now.year, now.month, 1);

    final history = await isar.goalHistorys
        .filter()
        .goalIdEqualTo(goalId)
        .and()
        .dateGreaterThan(startOfMonth)
        .findAll();

    return history.fold<int>(0, (sum, e) => sum + e.delta);
  }

  // metodo calcula el XP de acuerdo al momentum "DEPRECATED"
  int calculateXP(Momentum m) {
    switch (m.type) {
      case MomentumType.strong:
        return 20;
      case MomentumType.normal:
        return 10;
      case MomentumType.risk:
        return 5;
    }
  }
}
