import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:objetivos/data/entities/entities.dart';
import 'package:objetivos/infrastructure/entitites/momentum.dart';
import 'package:objetivos/presentations/providers/goal_message_state_provider.dart';
import 'package:objetivos/presentations/providers/movitation_service_provider.dart';
import 'package:objetivos/presentations/providers/sound_actived_provider.dart';
import 'package:objetivos/presentations/screens/home_screen.dart';

class MomentumBanner extends ConsumerStatefulWidget {
  final GoalMontly monthly;
  const MomentumBanner({super.key, required this.monthly});

  @override
  ConsumerState<MomentumBanner> createState() => _MomentumBannerState();
}

class _MomentumBannerState extends ConsumerState<MomentumBanner>
    with SingleTickerProviderStateMixin {
  bool reached = false;
  late AnimationController controller;
  late ConfettiController _confettiController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    reached = widget.monthly.completed;
    int duration = 2000;
    if (widget.monthly.completed) {
      duration = 3200;
    }
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: duration),
    )..forward();
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
        );
      }
    });
    _confettiController = ConfettiController(duration: Duration(seconds: 2));
  }

  @override
  void dispose() {
    super.dispose();
    _confettiController.dispose();
    _audioPlayer.dispose();
  }

  Future<void> playAudio(bool wantPlay) async {
    if (wantPlay) {
      try {
        await _audioPlayer.play(AssetSource('sounds/victory_trumpet.mp3'));
      } catch (e) {
        debugPrint('Error con audioPlayer $e');
      }
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool trigger = ref.watch(goalMessageStateProvider.notifier).trigger;
    final momentumProvider = ref.watch(motivationServiceProvider);
    final momentum = momentumProvider.calculateMomentum(widget.monthly);
    final isSoundActived = ref.watch(soundActivedProvider);
    ref.listen<GoalState>(goalMessageStateProvider, (previous, next) {
      if (previous?.messageState != GoalMessageState.success &&
          next.messageState == GoalMessageState.success) {
        ref.read(goalMessageStateProvider.notifier).setSuccessMessage();
        _confettiController.play();
        playAudio(isSoundActived);
      }
    });

    return Scaffold(
      body: FutureBuilder(
        future: momentum,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Stack(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween(
                          begin: const Offset(0, 0.2),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TransitionWidget(
                            trigger: trigger,
                            child: _MomentumCard(
                              reached: reached,
                              momentum: snapshot.data!,
                              montly: widget.monthly,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: ConfettiWidget(
                      confettiController: _confettiController,
                      blastDirectionality: BlastDirectionality.explosive,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class _MomentumCard extends ConsumerWidget {
  final Momentum momentum;
  final bool reached;
  final GoalMontly montly;
  const _MomentumCard({
    required this.momentum,
    required this.reached,
    required this.montly,
  });
  String getRandom(List<String> list) {
    return list[Random().nextInt(list.length)];
  }

  String _buildMessage(Momentum m, GoalState state) {
    final List<String> strong = [
      plural('strong-list.1', 10, args: [m.daysRemaining.toString()]),
      'strong-list.2',
      'strong-list.3',
      'strong-list.4',
      'strong-list.5',
      'strong-list.6',
      'strong-list.7',
      'strong-list.8',
    ];
    final List<String> normal = [
      'normal-list.1',
      'normal-list.2',
      'normal-list.3',
      'normal-list.4',
      'normal-list.5',
      'normal-list.6',
      'normal-list.7',
      'normal-list.8',
    ];
    final List<String> risk = [
      plural('risk-list.1', 1, args: [m.daysRemaining.toString()]),
      'risk-list.2',
      plural('risk-list.3', 1, args: [m.currentAverage.toString()]),
      'risk-list.4',
      'risk-list.5',
      plural('risk-list.6', 1, args: [m.daysRemaining.toString()]),
      'risk-list.7',
      'risk-list.8',
    ];
    if (state.messageState == GoalMessageState.motivating) {
      switch (m.type) {
        case MomentumType.strong:
          return getRandom(strong);
        case MomentumType.normal:
          return getRandom(normal);
        case MomentumType.risk:
          return getRandom(risk);
      }
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context, ref) {
    final state = ref.watch(goalMessageStateProvider);
    Color color;
    if (montly.completed) {
      ref.read(goalMessageStateProvider.notifier).goalCompleted();
    }
    if (state.messageState == GoalMessageState.motivating) {
      color = switch (momentum.type) {
        MomentumType.strong => Colors.green,
        MomentumType.normal => Colors.blue,
        MomentumType.risk => Colors.orange,
      };
    } else {
      color = Colors.red.shade200;
    }
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _AnimatedIcon(type: momentum.type, reached: reached),
          SizedBox(width: 12),
          Expanded(
            child: (state.messageState == GoalMessageState.motivating)
                ? Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      _buildMessage(momentum, state),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      ),
                    ).tr(),
                  )
                : Text(
                    textAlign: TextAlign.center,
                    state.motivationalMessage,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
                  ).tr(),
          ),
        ],
      ),
    );
  }
}

class _AnimatedIcon extends StatefulWidget {
  final MomentumType type;
  final bool reached;
  const _AnimatedIcon({required this.type, required this.reached});

  @override
  State<_AnimatedIcon> createState() => __AnimatedIconState();
}

class __AnimatedIconState extends State<_AnimatedIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  void triggerHaptic(MomentumType type) {
    if (type == MomentumType.strong) {
      HapticFeedback.heavyImpact();
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    triggerHaptic(widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: CurvedAnimation(parent: controller, curve: Curves.elasticOut),
      child: widget.reached
          ? Icon(Icons.emoji_events, color: Colors.amberAccent)
          : Icon(switch (widget.type) {
              MomentumType.strong => Icons.local_fire_department,
              MomentumType.normal => Icons.trending_up,
              MomentumType.risk => Icons.warning_amber,
            }, color: const Color.fromARGB(255, 240, 138, 54)),
    );
  }
}

class TransitionWidget extends StatefulWidget {
  final Widget child;
  final bool trigger;
  const TransitionWidget({
    super.key,
    required this.child,
    required this.trigger,
  });

  @override
  State<TransitionWidget> createState() => _TransitionWidgetState();
}

class _TransitionWidgetState extends State<TransitionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
  }

  void didUpdatedWidget(covariant TransitionWidget oldWidget) {
    if (widget.trigger && !oldWidget.trigger) {
      controller.forward(from: 0);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(begin: 1.0, end: 1.05).animate(controller),
      child: widget.child,
    );
  }
}
