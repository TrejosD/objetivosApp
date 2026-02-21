import 'package:flutter/material.dart';
import 'package:objetivos/data/db/isar_service.dart';
import 'package:objetivos/data/entities/goal_montly.dart';
import 'package:objetivos/data/repositorires/goal_repository.dart';
import 'package:objetivos/infrastructure/motivation/monthly_comparison.dart';
import 'package:objetivos/infrastructure/motivation/motivation_result.dart';
import 'package:objetivos/infrastructure/motivation/prediction.dart';

class MotivationService {
  final isar = IsarService.isar;
  final GoalRepository repo;

  MotivationService(this.repo);

  Future<MonthlyComparison> compareWithLastMonth(GoalMontly current) async {
    final prev = await repo.getPreviousMonth(current);

    if (prev == null) return MonthlyComparison.none();

    return MonthlyComparison(
      currentProgress: current.progress,
      previousProgress: prev.progress,
    );
  }

  Future<Prediction> predictGoal(GoalMontly monthly) async {
    final now = DateTime.now();

    final totalDays = DateUtils.getDaysInMonth(now.year, now.month);
    final remaining = totalDays - now.day;
    final average = await repo.getDailyAverage(monthly.goal.value!.id);

    final expected = monthly.progress + (average * remaining);
    final required = (monthly.target - monthly.progress) / remaining;

    return Prediction(
      willComplete: expected >= monthly.target,
      expectedProgress: expected,
      daysRemaining: remaining,
      requiredDaily: required,
    );
  }

  Future<MotivationResult> analyze(GoalMontly monthly) async {
    final comparison = await compareWithLastMonth(monthly);
    final prediction = await predictGoal(monthly);

    if (comparison.isBetter) {
      return MotivationResult(
        message: '🔥 Vas mejor que el mes pasado!',
        type: MotivationType.positive,
      );
    }
    if (prediction.willComplete) {
      return MotivationResult(
        message: '💪 Aún puedes lograrlo!',
        type: MotivationType.warning,
      );
    }
    return MotivationResult(
      message: '🚀 Sigue así!',
      type: MotivationType.positive,
    );
  }
}
