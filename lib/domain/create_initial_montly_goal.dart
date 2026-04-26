import 'package:objetivos/data/db/isar_service.dart';
import 'package:objetivos/data/entities/goal.dart';
import 'package:objetivos/data/entities/goal_montly.dart';

// este metodo permite reiniciar los objetivos cada mes a progreso 0, y guarda la info del mes anterior
Future<void> createInitialMontlyGoal(Goal goal) async {
  final isar = IsarService.isar;
  final now = DateTime.now();

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
