import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationMessageProvider =
    StateNotifierProvider<
      NotificationMessageNotifier,
      NotificationMessageState
    >((ref) {
      return NotificationMessageNotifier();
    });

class NotificationMessageNotifier
    extends StateNotifier<NotificationMessageState> {
  NotificationMessageNotifier() : super(NotificationMessageState(message: ''));

  final List<String> messageList = [
    'Estás a tiempo de continuar tu meta.',
    'Un paso más hoy.',
    'No rompas la racha.',
    'Tu meta te espera.',
    'Hoy también cuenta.',
    'Sigue el hábito.',
    'Pequeño esfuerzo, gran progreso.',
    'Hazlo ahora, te tomará poco.',
    'Tu yo de mañana lo agradecerá.',
  ];
  String getRandom(List<String> list) {
    return list[Random().nextInt(list.length)];
  }

  void getRandomMessage() {
    final message = getRandom(messageList);
    state = state.copyWith(message: message);
  }
}

class NotificationMessageState {
  final String message;
  NotificationMessageState({required this.message});

  NotificationMessageState copyWith({String? message}) =>
      NotificationMessageState(message: message ?? this.message);
}
