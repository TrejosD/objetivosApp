import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotifications {
  static Future<void> requestLocalNotificationPermissions() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  // metodo inicializa y configura local notification service
  static Future<void> initializeLocalNotifications() async {
    // todo probar con defaultIcon
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const initializationSettingsAndroid = AndroidInitializationSettings(
      'app_icon',
    );
    // todo IOS config
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    initializeTimeZone();
    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
    );
  }

  // metodo inicializa time zone service
  static void initializeTimeZone() async {
    final TimezoneInfo currentTimeZone =
        await FlutterTimezone.getLocalTimezone();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(currentTimeZone.identifier));
  }

  // metodo setea local notifications para mostrarse en un momento indicado "hora/dia/año"
  static void setScheduledLocalNotification({
    int id = 0,
    required String title,
    required String body,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    final scheduleDate = now.add(Duration(hours: 23));

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduleDate,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'channelId',
          'channelName',
          playSound: true,
          ongoing: true,
          channelDescription: 'notification',
        ),
      ),
      // android ScheduleMode permite notificaciones cual el mobile tiene bateria baja.
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      // este si se quiere repetir notificaciones daily | monthly
      // matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelNotification() async {
    final flutterNotificationPluggin = FlutterLocalNotificationsPlugin();
    await flutterNotificationPluggin.cancelAll();
  }

  // metodo para mostrar las local notification
  static void showLocalNotification({
    required int id,
    String? title,
    String? body,
    String? data,
  }) {
    const androidDetails = AndroidNotificationDetails(
      'channelId',
      'channelName',
      playSound: true,
      ongoing: true,
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      // todo IOSdetails
    );

    final flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: data,
    );
  }
}
