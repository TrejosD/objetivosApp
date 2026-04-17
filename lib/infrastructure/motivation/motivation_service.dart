import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:objetivos/data/db/isar_service.dart';
import 'package:objetivos/data/entities/entities.dart';
import 'package:objetivos/data/repositories/goal_repository.dart';
import 'package:objetivos/infrastructure/entitites/momentum.dart';
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
    final momentum = await calculateMomentum(monthly);

    if (momentum.type == MomentumType.strong) {
      return MotivationResult(
        message: '🔥 Vas adelantado, sigue Asi!',
        type: MotivationType.positive,
      );
    }
    if (momentum.type == MomentumType.risk) {
      return MotivationResult(
        message: '⚡ Necesitas acelerar para lograrlo. No te rindas',
        type: MotivationType.warning,
      );
    }
    return MotivationResult(
      message: '🚀 Sigue así!',
      type: MotivationType.positive,
    );
  }

  Future<Momentum> calculateMomentum(GoalMontly monthly) async {
    final now = DateTime.now();
    final totalDays = DateUtils.getDaysInMonth(now.year, now.month);

    final daysRemainig = totalDays - now.day;
    if (daysRemainig <= 0) {
      return Momentum(
        type: MomentumType.normal,
        requiredStreak: 0,
        dailyRequired: 0,
        currentAverage: 0,
        daysRemaining: 0,
      );
    }
    final avg = await repo.getDailyAverage(monthly.goal.value!.id);
    final remaining = monthly.target - monthly.progress;
    final requiredDaily = remaining - daysRemainig;
    if (avg == 0) {
      return Momentum(
        type: MomentumType.risk,
        requiredStreak: daysRemainig,
        dailyRequired: double.parse('$requiredDaily'),
        currentAverage: avg,
        daysRemaining: remaining,
      );
    }
    MomentumType type;

    if (avg >= requiredDaily * 1.2) {
      type = MomentumType.strong;
    } else if (avg >= requiredDaily) {
      type = MomentumType.normal;
    } else {
      type = MomentumType.risk;
    }

    final requiredStreak = (remaining / avg).ceil();
    return Momentum(
      type: type,
      requiredStreak: requiredStreak,
      dailyRequired: double.parse('$requiredDaily'),
      currentAverage: avg,
      daysRemaining: remaining,
    );
  }

  Future<int> getTotalProgressThisMonth(int goalId) async {
    final isar = IsarService.isar;
    final now = DateTime.now();

    final startOfMonth = DateTime(now.year, now.month, 1);
    final history = await isar.goalHistorys
        .filter()
        .goalIdEqualTo(goalId)
        .and()
        .dateGreaterThan(startOfMonth)
        .findAll();
    // todo Revisar donde funciona mejor este metodo, si ACa o en Motivation service
    return history.fold<int>(0, (sum, e) => sum + e.delta);
  }
}
