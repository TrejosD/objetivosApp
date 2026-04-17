import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:objetivos/data/entities/goal_montly.dart';
import 'package:objetivos/presentations/providers/goal_message_state_provider.dart';
import 'package:objetivos/presentations/providers/goal_streak_provider.dart';
import 'package:objetivos/presentations/providers/goals_montly_provider.dart';
import 'package:objetivos/presentations/providers/goals_repository_provider.dart';
import 'package:objetivos/presentations/screens/settings_screen.dart';
import 'package:objetivos/presentations/widgets/goal_dialog.dart';
import 'package:objetivos/presentations/widgets/momentum_banner.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final goals = ref.watch(goalsMontlyProvider);
    final goal = goals.value;
    late int streak = 0;
    if (goal == null || goal.isEmpty) {
      streak = 0;
    } else {
      final racha = ref.watch(goalStreakProvider(goal.first.id));
      streak = racha.when(
        data: (int data) => data,
        error: (_, __) => 0,
        loading: () => 0,
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => SettingsScreen()));
          },
          icon: Icon(Icons.settings),
        ),
        actions: [
          streak == 0
              ? SizedBox()
              : Row(
                  children: [
                    Icon(
                      Icons.local_fire_department_outlined,
                      color: Colors.orange,
                    ),
                    Text(plural('days-streaks', 1, args: [streak.toString()])),
                  ],
                ),
        ],
        title: Text('new Leaf'),
      ),
      body: goals.when(
        data: (goals) {
          if (goals.isEmpty) {
            return Center(child: Text('first-objetive').tr());
          }
          return ListView.builder(
            itemCount: goals.length,
            itemBuilder: (_, index) {
              final goal = goals[index];
              return AnimatedScale(
                scale: goal.completed ? 0.9 : 1,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
                child: GoalCard(goal: goal),
              );
            },
          );
        },
        error: (error, _) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (context) => GoalDialog());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class GoalCard extends ConsumerStatefulWidget {
  final GoalMontly goal;
  const GoalCard({super.key, required this.goal});

  @override
  ConsumerState<GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends ConsumerState<GoalCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bestStreak = widget.goal.goal.value!.bestStreak;
    final incrementProgress = ref
        .read(goalsRepositoryProvider)
        .incrementProgress;
    return Stack(
      children: [
        Card(
          color: widget.goal.completed ? Colors.green.shade200 : null,
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(9.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      widget.goal.goal.value?.name ?? "",
                      style: TextStyle(fontSize: 22),
                    ),
                    Spacer(),
                    bestStreak == 0
                        ? SizedBox()
                        : Row(
                            children: [
                              Icon(
                                Icons.local_fire_department_outlined,
                                color: Colors.orangeAccent,
                              ),
                              SizedBox(width: 3),
                              Text(
                                plural(
                                  'best-streak',
                                  1,
                                  args: [bestStreak.toString()],
                                ),
                              ),
                            ],
                          ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              GoalDialog(goal: widget.goal.goal.value),
                        );
                      },
                      icon: Icon(Icons.more_vert),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                  child: LinearProgressIndicator(
                    value: widget.goal.progress / widget.goal.target,
                  ),
                ),
                SizedBox(
                  width: 180,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          children: [
                            Text('goal-label').tr(),
                            SizedBox(width: 30),
                            Text('progress-label').tr(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 4,
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              child: Text(widget.goal.target.toString()),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(26, 0, 8, 0),
                              child: Text(widget.goal.progress.toString()),
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: widget.goal.completed
                                  ? null
                                  : () async {
                                      await incrementProgress(widget.goal, 1);
                                      ref
                                          .read(
                                            goalMessageStateProvider.notifier,
                                          )
                                          .reset();
                                      if (mounted) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MomentumBanner(
                                                  monthly: widget.goal,
                                                ),
                                          ),
                                        );
                                      }
                                    },
                              icon: Icon(Icons.add),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
