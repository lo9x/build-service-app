import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'demo-api-key',
    appId: '1:000000000000:web:demo',
    messagingSenderId: '000000000000',
    projectId: 'demo-project',
    authDomain: 'demo-project.firebaseapp.com',
    storageBucket: 'demo-project.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'demo-api-key',
    appId: '1:000000000000:android:demo',
    messagingSenderId: '000000000000',
    projectId: 'demo-project',
    storageBucket: 'demo-project.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'demo-api-key',
    appId: '1:000000000000:ios:demo',
    messagingSenderId: '000000000000',
    projectId: 'demo-project',
    iosBundleId: 'com.example.buildServiceApp',
    storageBucket: 'demo-project.appspot.com',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'demo-api-key',
    appId: '1:000000000000:macos:demo',
    messagingSenderId: '000000000000',
    projectId: 'demo-project',
    iosBundleId: 'com.example.buildServiceApp',
    storageBucket: 'demo-project.appspot.com',
  );
}
