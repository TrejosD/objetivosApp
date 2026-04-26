import 'package:objetivos/data/entities/entities.dart';

class GoalAggregate {
  final Goal goal;
  final GoalMontly montly;

  GoalAggregate(this.goal, this.montly);
}
