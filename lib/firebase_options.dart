import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
              'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
              'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
              'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA6XaDa-KNrDYlxnP--GSw-KRrmC6wqNAs',
    authDomain: 'mental-health-app-2eeeb.firebaseapp.com',
    projectId: 'mental-health-app-2eeeb',
    storageBucket: 'mental-health-app-2eeeb.firebasestorage.app',
    messagingSenderId: '176520889966',
    appId: '1:176520889966:web:5ed45d195702e060eac87f',
    measurementId: 'G-56M9FPG81K',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA1oPt3ZWz0PTYVHupkvPneyjhm4H_y1QQ',
    appId: '1:176520889966:android:dcbdcae0b8ad79e2eac87f',
    messagingSenderId: '176520889966',
    projectId: 'mental-health-app-2eeeb',
    storageBucket: 'mental-health-app-2eeeb.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA1oPt3ZWz0PTYVHupkvPneyjhm4H_y1QQ',
    appId: '1:176520889966:ios:dcbdcae0b8ad79e2eac87f',
    messagingSenderId: '176520889966',
    projectId: 'mental-health-app-2eeeb',
    storageBucket: 'mental-health-app-2eeeb.firebasestorage.app',
    iosBundleId: 'com.example.healthAppFixed',
  );
}