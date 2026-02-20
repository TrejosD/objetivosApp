import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:objetivos/data/repositorires/goal_repository.dart';

final appInitProvider = FutureProvider((ref) async {
  await GoalRepository().createMonthlyGoals();
});
