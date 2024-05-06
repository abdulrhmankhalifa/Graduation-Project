// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyC6t3bD00gCc9T4EXTI_KM9CrnwxHCt5n4',
    appId: '1:931943906136:web:1d9d4f1c8dcfc04dbbc32d',
    messagingSenderId: '931943906136',
    projectId: 'graduationproject-52a21',
    authDomain: 'graduationproject-52a21.firebaseapp.com',
    storageBucket: 'graduationproject-52a21.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA79fJNf76jYHha7p7SXxgzytin9kEC-ps',
    appId: '1:931943906136:android:f4afe49913bc1ffebbc32d',
    messagingSenderId: '931943906136',
    projectId: 'graduationproject-52a21',
    storageBucket: 'graduationproject-52a21.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA5_81pr5RI9eDUpmwQ2UTD0EFLqUVRgx8',
    appId: '1:931943906136:ios:aa88c1d38c374522bbc32d',
    messagingSenderId: '931943906136',
    projectId: 'graduationproject-52a21',
    storageBucket: 'graduationproject-52a21.appspot.com',
    iosBundleId: 'com.example.graduationProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA5_81pr5RI9eDUpmwQ2UTD0EFLqUVRgx8',
    appId: '1:931943906136:ios:7385e561b2a2ff8fbbc32d',
    messagingSenderId: '931943906136',
    projectId: 'graduationproject-52a21',
    storageBucket: 'graduationproject-52a21.appspot.com',
    iosBundleId: 'com.example.graduationProject.RunnerTests',
  );
}
