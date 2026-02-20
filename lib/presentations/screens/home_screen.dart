import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:objetivos/data/entities/goal_montly.dart';
import 'package:objetivos/presentations/providers/goal_streak_provider.dart';
import 'package:objetivos/presentations/providers/goals_montly_provider.dart';
import 'package:objetivos/presentations/providers/goals_repository_provider.dart';
import 'package:objetivos/presentations/widgets/goal_dialog.dart';
import 'package:vibration/vibration.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final goals = ref.watch(goalsMontlyProvider);
    final goal = goals.value?.first;
    final streak = ref.watch(goalStreakProvider(goal?.id ?? 0));
    return Scaffold(
      appBar: AppBar(
        actions: [
          streak.when(
            data: (streak) => streak == 0
                ? SizedBox()
                : Row(
                    children: [
                      Icon(Icons.local_fire_department, color: Colors.orange),
                      SizedBox(width: 3),
                      Text('$streak dias'),
                      SizedBox(width: 18),
                    ],
                  ),
            error: (_, __) => const SizedBox(),
            loading: () => const SizedBox(),
          ),
        ],
        title: Text('new Leaf'),
      ),
      body: goals.when(
        data: (goals) {
          if (goals.isEmpty) {
            return const Center(child: Text('Crea tu primer objetivo'));
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
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
  }

  @override
  dispose() {
    super.dispose();
    _confettiController.dispose();
  }

  final _audio = AudioPlayer();
  Future<void> _playFeedBack() async {
    if (await Vibration.hasVibrator() != false) {
      Vibration.vibrate(duration: 96);
    }
    await _audio.play(AssetSource('sounds/victory_trumpet.mp3'));
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
                              Text('Mejor racha $bestStreak'),
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
                            Text('Goal'),
                            SizedBox(width: 30),
                            Text('Progress'),
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
                                      final reached = await incrementProgress(
                                        widget.goal,
                                        1,
                                      );
                                      if (reached) {
                                        _confettiController.play();
                                        _playFeedBack();
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
        Center(
          heightFactor: 20,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
          ),
        ),
      ],
    );
  }
}
