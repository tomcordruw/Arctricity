// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...

final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

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

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDGnSle1ZEp6p-qp74ksFFYzGfh9g_Ouzo',
    appId: '1:594280156857:web:02254e064aa1083ae21568',
    messagingSenderId: '594280156857',
    projectId: 'springproject2023',
    authDomain: 'springproject2023.firebaseapp.com',
    storageBucket: 'springproject2023.appspot.com',
    measurementId: 'G-G7ZP9QMD1Z',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDGnSle1ZEp6p-qp74ksFFYzGfh9g_Ouzo',
    appId: '1:594280156857:web:02254e064aa1083ae21568',
    messagingSenderId: '594280156857',
    projectId: 'springproject2023',
    authDomain: 'springproject2023.firebaseapp.com',
    storageBucket: 'springproject2023.appspot.com',
    measurementId: 'G-G7ZP9QMD1Z',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCW2Y7hojoHa4Y1aJA2YwICgW1WqBQw3M4',
    appId: '1:594280156857:android:8324716ba7848a33e21568',
    messagingSenderId: '594280156857',
    projectId: 'springproject2023',
    storageBucket: 'springproject2023.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDCEQyeFQ8SuK0LkQHK33NjoLy_I_XdpSc',
    appId: '1:594280156857:ios:a9ddd784e4563e9de21568',
    messagingSenderId: '594280156857',
    projectId: 'springproject2023',
    storageBucket: 'springproject2023.appspot.com',
    iosClientId:
        '594280156857-sgnautf1bhffm0rr6mk6ku64f6jcrgld.apps.googleusercontent.com',
    iosBundleId: 'com.example.projectNew',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDCEQyeFQ8SuK0LkQHK33NjoLy_I_XdpSc',
    appId: '1:594280156857:ios:a9ddd784e4563e9de21568',
    messagingSenderId: '594280156857',
    projectId: 'springproject2023',
    storageBucket: 'springproject2023.appspot.com',
    iosClientId:
        '594280156857-sgnautf1bhffm0rr6mk6ku64f6jcrgld.apps.googleusercontent.com',
    iosBundleId: 'com.example.projectNew',
  );
}