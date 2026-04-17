import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:objetivos/data/db/isar_service.dart';
import 'package:objetivos/data/entities/goal_montly.dart';

// este stream provee la lista de objetivos que puede ver el usuario
final goalsMontlyProvider = StreamProvider<List<GoalMontly>>((ref) {
  final now = DateTime.now();

  return IsarService.isar.goalMontlys
      .filter()
      .yearEqualTo(now.year)
      .and()
      .monthEqualTo(now.month)
      .watch(fireImmediately: true);
});
