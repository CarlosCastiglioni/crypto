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
    apiKey: 'AIzaSyD1p0X-Yu0DYCGjGPSoBX6MKaxKPGaV4L0',
    appId: '1:593084315902:web:56f6d8f5574e840d01cdaf',
    messagingSenderId: '593084315902',
    projectId: 'crypto-989bf',
    authDomain: 'crypto-989bf.firebaseapp.com',
    storageBucket: 'crypto-989bf.appspot.com',
    measurementId: 'G-6WBW41TP1L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAevU4AwyUslz7QScD7w-KQ4ML3LDWiPgs',
    appId: '1:593084315902:android:f017162d74745ff901cdaf',
    messagingSenderId: '593084315902',
    projectId: 'crypto-989bf',
    storageBucket: 'crypto-989bf.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD-xu3iOG6hmOF9LsfQiZ5ba7d5QNRq9Y0',
    appId: '1:593084315902:ios:28019e5cca2e3fad01cdaf',
    messagingSenderId: '593084315902',
    projectId: 'crypto-989bf',
    storageBucket: 'crypto-989bf.appspot.com',
    androidClientId: '593084315902-illt9fptel8solq3prhcmj74bak1h729.apps.googleusercontent.com',
    iosClientId: '593084315902-lnod342inp54s5h26ctehfr6kd331m9a.apps.googleusercontent.com',
    iosBundleId: 'com.example.crypto',
  );
}
