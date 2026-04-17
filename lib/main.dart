import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:objetivos/config/local_notifications/local_notifications.dart';
import 'package:objetivos/config/theme/app_theme.dart';
import 'package:objetivos/firebase_options.dart';
import 'package:objetivos/infrastructure/helpers/notification_service.dart';
import 'package:objetivos/infrastructure/helpers/shared_preferences_service.dart';
import 'package:objetivos/presentations/providers/app_init_provider.dart';
import 'package:objetivos/presentations/providers/notifications_service_provider.dart';
import 'package:objetivos/presentations/screens/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:objetivos/data/db/isar_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await IsarService.init();
  await SharedPreferencesService.getPreference();
  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await LocalNotifications.initializeLocalNotifications();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(
    NotificationService.firebaseMessagingBackgroundHandler,
  );
  final prefs = SharedPreferencesService.prefs;
  final String? savedLocale = prefs.getString('locale');
  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('es', 'LA'),
        Locale('en', 'US'),
        Locale('zh', 'CN'),
        Locale('ja', 'JPN'),
      ],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      startLocale: savedLocale != null ? Locale(savedLocale) : null,
      child: ProviderScope(child: MyApp(prefs: prefs)),
    ),
  );
}

class MyApp extends ConsumerWidget {
  final SharedPreferences prefs;
  const MyApp({super.key, required this.prefs});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, ref) {
    var brightness = MediaQuery.of(context).platformBrightness;
    final bOveride = prefs.getString('brightness');

    ref.watch(appInitProvider);
    ref.read(notificationsServiceProvider).init();
    return MaterialApp(
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme(
        brightness: brightness,
        brighnessOveride: bOveride,
      ).theme(),
      home: const HomeScreen(),
    );
  }
}
