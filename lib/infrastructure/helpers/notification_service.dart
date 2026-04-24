import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:objetivos/domain/entitites/push_messages.dart';

// control y manejo de las push notificaions
class NotificationService {
  final FirebaseMessaging messaging;
  final void Function({
    required int id,
    String? title,
    String? body,
    String? data,
  })
  localNotifications;
  final Future<void> Function() requestLocalNotificationPermission;
  NotificationService(
    this.messaging,
    this.localNotifications,
    this.requestLocalNotificationPermission,
  );
  // inicializar las push notifications perdir permisos, obtener el token...
  Future<void> init() async {
    await _requestPermission();
    _onForegroundMessage();
    _getToken();
  }

  // metodo estatico, maneja las push notifications cuando app esta cerrada "Background"
  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();
  }

  // llamar este metodo, para solicitar permisos de notificaciones
  Future<void> _requestPermission() async {
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await requestLocalNotificationPermission();
  }

  // metodo estatico, maneja las push notifications como local Notifications
  void _handleRemoteMessage(RemoteMessage message) {
    int idNumber = 0;
    final notification = PushMessages(
      messageId:
          message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '',
      title: message.notification!.title ?? '',
      body: message.notification!.body ?? '',
      sentDate: message.sentTime ?? DateTime.now(),
    );
    localNotifications(
      id: idNumber++,
      body: notification.body,
      data: notification.data.toString(),
      title: notification.title,
    );
  }

  // metodo estatico, maneja las push notifications cuando app esta abierta "foreground"
  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(_handleRemoteMessage);
    // await FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('Usuario abrio la notificacion');
    // });
  }

  // metodo imprime el FCMToken
  Future<void> _getToken() async {
    await messaging.getToken();
  }
}
