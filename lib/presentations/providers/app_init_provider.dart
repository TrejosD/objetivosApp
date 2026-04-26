import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:objetivos/data/repositories/goal_repository.dart';

// servicio que reinicia el progreso de los objetivos cada cambio de mes
final appInitProvider = FutureProvider((ref) async {
  await GoalRepository().createMonthlyGoals();
});
