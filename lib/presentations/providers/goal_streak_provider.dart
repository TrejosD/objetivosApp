import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:objetivos/presentations/providers/goals_repository_provider.dart';

final goalStreakProvider = FutureProvider.family<int, int>((ref, goalId) {
  final repo = ref.read(goalsRepositoryProvider);
  return repo.getCurrentStreak(goalId);
});
