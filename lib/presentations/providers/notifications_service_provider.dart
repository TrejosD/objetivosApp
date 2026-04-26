import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:objetivos/config/local_notifications/local_notifications.dart';
import 'package:objetivos/infrastructure/helpers/notification_service.dart';
import 'package:objetivos/presentations/providers/firebase_messaging_provider.dart';

// este provider provee el servicio de notificaciones local y push
final notificationsServiceProvider = Provider<NotificationService>((ref) {
  final messaging = ref.watch(firebaseMessagingProvider);
  final void Function({
    required int id,
    String? title,
    String? body,
    String? data,
  })
  localNotifications = LocalNotifications.showLocalNotification;
  final requestLocalNotificationPermission =
      LocalNotifications.requestLocalNotificationPermissions;
  return NotificationService(
    messaging,
    localNotifications,
    requestLocalNotificationPermission,
  );
});
