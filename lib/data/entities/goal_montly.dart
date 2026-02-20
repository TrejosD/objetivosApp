import 'package:isar/isar.dart';
import 'goal.dart';
part 'goal_montly.g.dart';

@collection
class GoalMontly {
  Id id = Isar.autoIncrement;

  late int year;
  late int month;
  late int target;
  late int progress;
  bool completed = false;

  final goal = IsarLink<Goal>();
}
