import 'package:isar/isar.dart';
part 'goal_history.g.dart';

@collection
class GoalHistory {
  Id id = Isar.autoIncrement;

  late int goalId;
  late int progress;
  late DateTime date;
  int delta = 0;
}
