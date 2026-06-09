import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

import 'app_config.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      default:
        throw UnsupportedError('Firebase is not configured for this platform.');
    }
  }

  static FirebaseOptions get web => FirebaseOptions(
    apiKey: AppConfig.firebaseWebApiKey,
    appId: AppConfig.firebaseWebAppId,
    messagingSenderId: AppConfig.firebaseWebMessagingSenderId,
    projectId: AppConfig.firebaseWebProjectId,
    authDomain: AppConfig.firebaseWebAuthDomain,
    storageBucket: AppConfig.firebaseWebStorageBucket,
  );

  static FirebaseOptions get android => FirebaseOptions(
    apiKey: AppConfig.firebaseAndroidApiKey,
    appId: AppConfig.firebaseAndroidAppId,
    messagingSenderId: AppConfig.firebaseAndroidMessagingSenderId,
    projectId: AppConfig.firebaseAndroidProjectId,
    storageBucket: AppConfig.firebaseAndroidStorageBucket,
  );

  static FirebaseOptions get ios => FirebaseOptions(
    apiKey: AppConfig.firebaseIosApiKey,
    appId: AppConfig.firebaseIosAppId,
    messagingSenderId: AppConfig.firebaseIosMessagingSenderId,
    projectId: AppConfig.firebaseIosProjectId,
    iosBundleId: AppConfig.firebaseIosBundleId,
    storageBucket: AppConfig.firebaseIosStorageBucket,
  );

  static FirebaseOptions get macos => FirebaseOptions(
    apiKey: AppConfig.firebaseMacosApiKey,
    appId: AppConfig.firebaseMacosAppId,
    messagingSenderId: AppConfig.firebaseMacosMessagingSenderId,
    projectId: AppConfig.firebaseMacosProjectId,
    iosBundleId: AppConfig.firebaseMacosBundleId,
    storageBucket: AppConfig.firebaseMacosStorageBucket,
  );
}
