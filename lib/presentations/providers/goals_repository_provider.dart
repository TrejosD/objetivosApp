import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:objetivos/data/repositories/goal_repository.dart';

final goalsRepositoryProvider = Provider<GoalRepository>((ref) {
  return GoalRepository();
});
