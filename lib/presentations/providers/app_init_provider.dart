import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:objetivos/data/repositories/goal_repository.dart';

final appInitProvider = FutureProvider((ref) async {
  await GoalRepository().createMonthlyGoals();
});
