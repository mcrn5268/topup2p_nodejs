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
    apiKey: 'AIzaSyCZVyu6UpC2RUlK7L25NSXiGFJrfx-jIdk',
    appId: '1:514672857524:web:70aa8b53e96758edfb22e1',
    messagingSenderId: '514672857524',
    projectId: 'topup2p-nodejs',
    authDomain: 'topup2p-nodejs.firebaseapp.com',
    storageBucket: 'topup2p-nodejs.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAJTy-RkLDt-BEO-2gjPmUuEHvM-PF-dqI',
    appId: '1:514672857524:android:63fd805d00f20ba7fb22e1',
    messagingSenderId: '514672857524',
    projectId: 'topup2p-nodejs',
    storageBucket: 'topup2p-nodejs.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBOTavWd1Vchwakqv_6UzFbYw6ez3cxlhY',
    appId: '1:514672857524:ios:25cffbb7fd297b63fb22e1',
    messagingSenderId: '514672857524',
    projectId: 'topup2p-nodejs',
    storageBucket: 'topup2p-nodejs.appspot.com',
    iosClientId: '514672857524-hq4rk70vk9hga6ke8lknn6qe2c6r72n9.apps.googleusercontent.com',
    iosBundleId: 'com.example.topup2pNodejs',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBOTavWd1Vchwakqv_6UzFbYw6ez3cxlhY',
    appId: '1:514672857524:ios:25cffbb7fd297b63fb22e1',
    messagingSenderId: '514672857524',
    projectId: 'topup2p-nodejs',
    storageBucket: 'topup2p-nodejs.appspot.com',
    iosClientId: '514672857524-hq4rk70vk9hga6ke8lknn6qe2c6r72n9.apps.googleusercontent.com',
    iosBundleId: 'com.example.topup2pNodejs',
  );
}
