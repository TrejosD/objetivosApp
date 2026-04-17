import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String androidApiKey = dotenv.env['ANDROID_API_KEY'] ?? 'NO-API-KEY';
  static String androidApiId = dotenv.env['ANDROID_API_ID'] ?? 'NO-API-ID';
  static String androidMessagingSenderId =
      dotenv.env['ANDROID_MESSAGING_SENDER_ID'] ?? 'NO-MESSAGING-SENDER-ID';
  static String androidProjectId =
      dotenv.env['ANDROID_PROJECT_ID'] ?? 'NO-PROJECT-ID';
  static String androidStorageBucket =
      dotenv.env['ANDROID_STORAGE_BUCKET'] ?? 'NO-STORAGE-BUCKET';
  static String iosApiKey = dotenv.env['IOS_API_KEY'] ?? 'NO-API-KEY';
  static String iosApiId = dotenv.env['IOS_API_ID'] ?? 'NO-API-ID';
  static String iosMessagingSenderId =
      dotenv.env['IOS_MESSAGING_SENDER_ID'] ?? 'NO_MESSAGING_SENDER_ID';
  static String iosProjectId = dotenv.env['IOS_PROJECT_ID'] ?? 'NO-PROJECT-ID';
  static String iosStorageBucket =
      dotenv.env['IOS_STORAGE_BUCKET'] ?? 'NO-STORAGE-BUCKET';
  static String iosBundleId = dotenv.env['IOS_BUNDLE_ID'] ?? 'NO-BUNDLE-ID';
}
