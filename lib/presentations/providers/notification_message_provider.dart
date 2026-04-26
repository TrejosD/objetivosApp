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
    'notification-list.1',
    'notification-list.2',
    'notification-list.3',
    'notification-list.4',
    'notification-list.5',
    'notification-list.6',
    'notification-list.7',
    'notification-list.8',
    'notification-list.9',
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
