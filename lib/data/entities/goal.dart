import 'package:isar/isar.dart';
import 'goal_montly.dart';

part 'goal.g.dart';

@collection
class Goal {
  Id id = Isar.autoIncrement;
  late String name;
  late int target;
  int bestStreak = 0;
  final history = IsarLink<GoalMontly>();
}
