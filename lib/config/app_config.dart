import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static bool get useMockApi => _boolValue(
        envKey: 'USE_MOCK_API',
        dartDefineKey: 'USE_MOCK_API',
        defaultValue: true,
      );

  static bool get enableFirebaseGoogleAuth => _boolValue(
        envKey: 'ENABLE_FIREBASE_GOOGLE_AUTH',
        dartDefineKey: 'ENABLE_FIREBASE_GOOGLE_AUTH',
        defaultValue: false,
      );

  static String get apiBaseUrl => _stringValue(
        envKey: 'API_BASE_URL',
        dartDefineKey: 'API_BASE_URL',
        defaultValue: 'http://10.0.2.2:3000',
      );

  static String get firebaseWebApiKey => _stringValue(
        envKey: 'FIREBASE_WEB_API_KEY',
        dartDefineKey: 'FIREBASE_WEB_API_KEY',
      );

  static String get firebaseWebAppId => _stringValue(
        envKey: 'FIREBASE_WEB_APP_ID',
        dartDefineKey: 'FIREBASE_WEB_APP_ID',
      );

  static String get firebaseWebMessagingSenderId => _stringValue(
        envKey: 'FIREBASE_WEB_MESSAGING_SENDER_ID',
        dartDefineKey: 'FIREBASE_WEB_MESSAGING_SENDER_ID',
      );

  static String get firebaseWebProjectId => _stringValue(
        envKey: 'FIREBASE_WEB_PROJECT_ID',
        dartDefineKey: 'FIREBASE_WEB_PROJECT_ID',
      );

  static String get firebaseWebAuthDomain => _stringValue(
        envKey: 'FIREBASE_WEB_AUTH_DOMAIN',
        dartDefineKey: 'FIREBASE_WEB_AUTH_DOMAIN',
      );

  static String get firebaseWebStorageBucket => _stringValue(
        envKey: 'FIREBASE_WEB_STORAGE_BUCKET',
        dartDefineKey: 'FIREBASE_WEB_STORAGE_BUCKET',
      );

  static String get firebaseAndroidApiKey => _stringValue(
        envKey: 'FIREBASE_ANDROID_API_KEY',
        dartDefineKey: 'FIREBASE_ANDROID_API_KEY',
      );

  static String get firebaseAndroidAppId => _stringValue(
        envKey: 'FIREBASE_ANDROID_APP_ID',
        dartDefineKey: 'FIREBASE_ANDROID_APP_ID',
      );

  static String get firebaseAndroidMessagingSenderId => _stringValue(
        envKey: 'FIREBASE_ANDROID_MESSAGING_SENDER_ID',
        dartDefineKey: 'FIREBASE_ANDROID_MESSAGING_SENDER_ID',
      );

  static String get firebaseAndroidProjectId => _stringValue(
        envKey: 'FIREBASE_ANDROID_PROJECT_ID',
        dartDefineKey: 'FIREBASE_ANDROID_PROJECT_ID',
      );

  static String get firebaseAndroidStorageBucket => _stringValue(
        envKey: 'FIREBASE_ANDROID_STORAGE_BUCKET',
        dartDefineKey: 'FIREBASE_ANDROID_STORAGE_BUCKET',
      );

  static String get firebaseIosApiKey => _stringValue(
        envKey: 'FIREBASE_IOS_API_KEY',
        dartDefineKey: 'FIREBASE_IOS_API_KEY',
      );

  static String get firebaseIosAppId => _stringValue(
        envKey: 'FIREBASE_IOS_APP_ID',
        dartDefineKey: 'FIREBASE_IOS_APP_ID',
      );

  static String get firebaseIosMessagingSenderId => _stringValue(
        envKey: 'FIREBASE_IOS_MESSAGING_SENDER_ID',
        dartDefineKey: 'FIREBASE_IOS_MESSAGING_SENDER_ID',
      );

  static String get firebaseIosProjectId => _stringValue(
        envKey: 'FIREBASE_IOS_PROJECT_ID',
        dartDefineKey: 'FIREBASE_IOS_PROJECT_ID',
      );

  static String get firebaseIosStorageBucket => _stringValue(
        envKey: 'FIREBASE_IOS_STORAGE_BUCKET',
        dartDefineKey: 'FIREBASE_IOS_STORAGE_BUCKET',
      );

  static String get firebaseIosBundleId => _stringValue(
        envKey: 'FIREBASE_IOS_BUNDLE_ID',
        dartDefineKey: 'FIREBASE_IOS_BUNDLE_ID',
      );

  static String get firebaseMacosApiKey => _stringValue(
        envKey: 'FIREBASE_MACOS_API_KEY',
        dartDefineKey: 'FIREBASE_MACOS_API_KEY',
      );

  static String get firebaseMacosAppId => _stringValue(
        envKey: 'FIREBASE_MACOS_APP_ID',
        dartDefineKey: 'FIREBASE_MACOS_APP_ID',
      );

  static String get firebaseMacosMessagingSenderId => _stringValue(
        envKey: 'FIREBASE_MACOS_MESSAGING_SENDER_ID',
        dartDefineKey: 'FIREBASE_MACOS_MESSAGING_SENDER_ID',
      );

  static String get firebaseMacosProjectId => _stringValue(
        envKey: 'FIREBASE_MACOS_PROJECT_ID',
        dartDefineKey: 'FIREBASE_MACOS_PROJECT_ID',
      );

  static String get firebaseMacosStorageBucket => _stringValue(
        envKey: 'FIREBASE_MACOS_STORAGE_BUCKET',
        dartDefineKey: 'FIREBASE_MACOS_STORAGE_BUCKET',
      );

  static String get firebaseMacosBundleId => _stringValue(
        envKey: 'FIREBASE_MACOS_BUNDLE_ID',
        dartDefineKey: 'FIREBASE_MACOS_BUNDLE_ID',
      );

  static bool _boolValue({
    required String envKey,
    required String dartDefineKey,
    required bool defaultValue,
  }) {
    final envValue = dotenv.maybeGet(envKey);
    if (envValue != null && envValue.isNotEmpty) {
      return envValue.toLowerCase() == 'true';
    }
    const dartValue = String.fromEnvironment(dartDefineKey, defaultValue: '');
    if (dartValue.isNotEmpty) {
      return dartValue.toLowerCase() == 'true';
    }
    return defaultValue;
  }

  static String _stringValue({
    required String envKey,
    required String dartDefineKey,
    String defaultValue = '',
  }) {
    final envValue = dotenv.maybeGet(envKey);
    if (envValue != null && envValue.isNotEmpty) {
      return envValue;
    }
    const dartValue = String.fromEnvironment(dartDefineKey, defaultValue: '');
    if (dartValue.isNotEmpty) {
      return dartValue;
    }
    return defaultValue;
  }
}
