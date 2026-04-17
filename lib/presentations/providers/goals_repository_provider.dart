import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:objetivos/data/repositories/goal_repository.dart';

// este provider provee el repositorio donde se guarda la info de los objetivos
final goalsRepositoryProvider = Provider<GoalRepository>((ref) {
  return GoalRepository();
});
