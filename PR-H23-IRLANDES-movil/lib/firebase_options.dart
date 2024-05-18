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
    apiKey: 'AIzaSyDZMeWFpZbUSvB-0bExxZ5cnsKOHo3hOHw',
    appId: '1:574512265912:web:1e4be5204a94920e81524d',
    messagingSenderId: '574512265912',
    projectId: 'pr-irlandes',
    authDomain: 'pr-irlandes.firebaseapp.com',
    storageBucket: 'pr-irlandes.appspot.com',
    measurementId: 'G-KN5MVWVKJ6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCRGT1pJ0lfyfyipHKP4alEjG1R8-TVgkY',
    appId: '1:574512265912:android:a3d5e1ccdef45aff81524d',
    messagingSenderId: '574512265912',
    projectId: 'pr-irlandes',
    storageBucket: 'pr-irlandes.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCHPADuGOel0ZE-doqdy3LbMIYWFsV5YLk',
    appId: '1:574512265912:ios:718bc434b112971c81524d',
    messagingSenderId: '574512265912',
    projectId: 'pr-irlandes',
    storageBucket: 'pr-irlandes.appspot.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCHPADuGOel0ZE-doqdy3LbMIYWFsV5YLk',
    appId: '1:574512265912:ios:3b62a5bf4751d64081524d',
    messagingSenderId: '574512265912',
    projectId: 'pr-irlandes',
    storageBucket: 'pr-irlandes.appspot.com',
    iosBundleId: 'com.example.flutterApplication1.RunnerTests',
  );
}
