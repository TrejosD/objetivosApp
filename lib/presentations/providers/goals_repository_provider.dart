import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:objetivos/data/repositorires/goal_repository.dart';

final goalsRepositoryProvider = Provider<GoalRepository>((ref) {
  return GoalRepository();
});
