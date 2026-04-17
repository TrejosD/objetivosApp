import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:objetivos/config/local_notifications/local_notifications.dart';
import 'package:objetivos/domain/entitites/push_messages.dart';

class NotificationService {
  final FirebaseMessaging messaging;
  NotificationService(this.messaging);

  // todo necesito un stado para las notificaciones, donde tener la autorizacion y la lista de notificaciones
  Future<void> init() async {
    await _requestPermission();
    _onForegroundMessage();
    _getToken();
  }

  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();

    print("Handling a background message: ${message.messageId}");
  }

  // llamar este metodo, para solicitar permisos de notificaciones
  Future<void> _requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await LocalNotifications.requestLocalNotificationPermissions();
    print(settings);
  }

  void _handleRemoteMessage(RemoteMessage message) {
    int idNumber = 0;
    final notification = PushMessages(
      messageId:
          message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '',
      title: message.notification!.title ?? '',
      body: message.notification!.body ?? '',
      sentDate: message.sentTime ?? DateTime.now(),
    );
    LocalNotifications.showLocalNotification(
      id: ++idNumber,
      body: notification.body,
      data: notification.data.toString(),
      title: notification.title,
    );
  }

  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(_handleRemoteMessage);
    // await FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('Usuario abrio la notificacion');
    // });
  }

  Future<void> _getToken() async {
    final token = await messaging.getToken();
    print('FCM Token $token');
  }
}
