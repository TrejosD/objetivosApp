import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:objetivos/infrastructure/helpers/notification_service.dart';
import 'package:objetivos/presentations/providers/firebase_messaging_provider.dart';

final notificationsServiceProvider = Provider<NotificationService>((ref) {
  final messaging = ref.watch(firebaseMessagingProvider);
  return NotificationService(messaging);
});
