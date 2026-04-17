import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum GoalMessageState { motivating, success, victory }

final goalMessageStateProvider = StateNotifierProvider<GoalNotifier, GoalState>(
  (ref) {
    return GoalNotifier();
  },
);

class GoalNotifier extends StateNotifier<GoalState> {
  Timer? _transitionTimer;
  bool trigger = true;
  GoalNotifier()
    : super(
        GoalState(
          isCompleted: false,
          messageState: GoalMessageState.motivating,
          motivationalMessage: '',
        ),
      );

  @override
  void dispose() {
    _transitionTimer?.cancel();
    super.dispose();
  }

  // metodo cambia el state cuando el goal mensual es completado
  void goalCompleted() {
    if (state.isCompleted) return;

    _transitionTimer?.cancel();
    _transitionTimer = Timer(Duration(milliseconds: 1000), () {
      trigger = !trigger;
      state = state.copyWith(messageState: GoalMessageState.success);
    });
  }

  void setSuccessMessage() {
    final List<String> success = [
      'success-list.1',
      'success-list.2',
      'success-list.3',
      'success-list.4',
      'success-list.5',
      'success-list.6',
      'success-list.7',
      'success-list.8',
    ];

    state = state.copyWith(motivationalMessage: getRandom(success));
  }

  String getRandom(List<String> list) {
    return list[Random().nextInt(list.length)];
  }

  void reset() {
    _transitionTimer?.cancel();
    trigger = true;
    state = state.copyWith(
      isCompleted: false,
      messageState: GoalMessageState.motivating,
    );
  }
}

class GoalState {
  final bool isCompleted;
  final GoalMessageState messageState;
  final String motivationalMessage;

  GoalState({
    required this.isCompleted,
    required this.messageState,
    required this.motivationalMessage,
  });

  GoalState copyWith({
    bool? isCompleted,
    GoalMessageState? messageState,
    String? motivationalMessage,
  }) => GoalState(
    isCompleted: isCompleted ?? this.isCompleted,
    messageState: messageState ?? this.messageState,
    motivationalMessage: motivationalMessage ?? this.motivationalMessage,
  );
}
