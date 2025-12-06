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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    appId: '1:176520889966:web:5ed45d195702e060eac87f',
    messagingSenderId: '176520889966',
    projectId: 'mental-health-app-2eeeb',
    authDomain: 'mental-health-app-2eeeb.firebaseapp.com',
    storageBucket: 'mental-health-app-2eeeb.firebasestorage.app',
    measurementId: 'G-56M9FPG81K',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA1oPt3ZWz0PTYVHupkvPneyjhm4H_y1QQ',
    appId: '1:176520889966:android:ab97ef47b5f41199eac87f',
    messagingSenderId: '176520889966',
    projectId: 'mental-health-app-2eeeb',
    storageBucket: 'mental-health-app-2eeeb.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDEtn2wdjDxYkMxittIN77ZqL-o2PLGjqY',
    appId: '1:176520889966:ios:099b3126b53b65baeac87f',
    messagingSenderId: '176520889966',
    projectId: 'mental-health-app-2eeeb',
    storageBucket: 'mental-health-app-2eeeb.firebasestorage.app',
    iosClientId: '176520889966-j40n2g28mq3njtb3ktsoinacv3av20an.apps.googleusercontent.com',
    iosBundleId: 'com.example.healthAppNew',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDEtn2wdjDxYkMxittIN77ZqL-o2PLGjqY',
    appId: '1:176520889966:ios:099b3126b53b65baeac87f',
    messagingSenderId: '176520889966',
    projectId: 'mental-health-app-2eeeb',
    storageBucket: 'mental-health-app-2eeeb.firebasestorage.app',
    iosClientId: '176520889966-j40n2g28mq3njtb3ktsoinacv3av20an.apps.googleusercontent.com',
    iosBundleId: 'com.example.healthAppNew',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA6XaDa-KNrDYlxnP--GSw-KRrmC6wqNAs',
    appId: '1:176520889966:web:e258d2eac0b87bffeac87f',
    messagingSenderId: '176520889966',
    projectId: 'mental-health-app-2eeeb',
    authDomain: 'mental-health-app-2eeeb.firebaseapp.com',
    storageBucket: 'mental-health-app-2eeeb.firebasestorage.app',
    measurementId: 'G-H1TLW1BMWH',
  );

}