import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb)
    {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for fuchsia - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDfVBjFEDlfD8m6peYcmuOcf3yLxrU3tIY',
    appId: '1:247392275240:android:5ac219ce9ec4b9baf71e1d',
    messagingSenderId: '247392275240',
    projectId: 'ipc-attendee',
    storageBucket: 'ipc-attendee.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDfVBjFEDlfD8m6peYcmuOcf3yLxrU3tIY',
    appId: '1:247392275240:android:5ac219ce9ec4b9baf71e1d',
    messagingSenderId: '247392275240',
    projectId: 'ipc-attendee',
    storageBucket: 'ipc-attendee.firebasestorage.app',
    androidClientId: '63168540332-bf5kqt19bbbq0ub3quibe67tfi7hjc1v.apps.googleusercontent.com',
    iosClientId: '63168540332-b8snl3ggfeaosrq8acqc11npalhouus5.apps.googleusercontent.com',
    iosBundleId: 'com.ipc.delegates',
  );
}
